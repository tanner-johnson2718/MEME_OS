//*****************************************************************************
// Building, Running, and demo)
//----------------------------------------------------
// - make
// - sudo ./pthread
// - See /var/log/syslog to see the output of the demo
//
// Commenting and Improving)
//----------------------------------------------------
// - Entire file rewrote to simplify and clarify the fundamental functionality
//   that the code is trying to explify. That is creating RT threads and
//   mapping them to CPU cores.
// - Well commented to explain code
//
// Walk Through)
//----------------------------------------------------
// - Main
//   - We use CPU_ macros to set a cpu bit mask to target CPU 0 only
//   - Use sched_setaffinity()  to actually set the affinity of the main thread
//   - We set the scheduler priority to max
//   - use the sched_setscheduler system call to set the process to max 
//     priority using the real time SCHED_FIFO scheduler
//   - The two sched_* system calls require root access so we add error guards
//     to catch that.
// - Spawn Threads
//   - For each thread we intent to spawn we set the CPU bit mask to the thread
//     id mod 4 or the number of cpus so the threads get distribute as evenly
//     as possible across the 4 cores.
//   - We use the pthread_attr_* setter calls to set each thread attribute to:
//      - That thread id’s core assignment
//      - Use SCHED_FIFO real time scheduling
//      - Max priority
//      - Set inherit sched to explicit so it uses are explicit sched attributes 
//        we set
//   - Finally we launch all the threads using pthread_create()
// - RT FIFO Behavior
//   - The main thread and all 128 counter threads are of max prio
//   - Thus all threads occupy the same FIFO queue and are in the order: 
//     {main,0,1,...,127}.
//   - Since the threads target different CPUs, threads targeting the same 
//     CPU will be ran in order and preempted only when the previous thread 
//     finishes
//   - As an example, CPU 1 will be occupied by thread 1 until it finishes.
//   - Thread 5 will take over, followed by {5,9, …, 125}.
//   - This behavior is analogous for CPU 2 and 3.
//   - CPU 0 is slightly different because it shares execution with main that
//     has a blocking system call.
// - RT FIFO Behavior CPU 0 
//   - The execution order for CPU 0 is as follows, {main, 0,4,8, …, 124, main}
//   - The first instance of main executing is when main is calling 
//     pthread_create.
//   - It will hold the CPU until it finishes creating all threads and will 
//     yield when it hits the first pthread_join, waiting for thread 0 to die
//   - Thread 0 takes over the CPU, and finishes executing.
//   - At this point main because runnable and is placed at the end of the FIFO
//   - Threads {4,8,...124} finish executing
//   - Main takes back CPU 0 to finish processing the pthread_join calls
//
// Debugging)
//----------------------------------------------------
// - sudo gdb ./posix_clock
// - Code has lots of threads to practice using gdb to debug multithreaded
//   programs
// - b main to break at main
// - b counterThread to break when a thread starts
// - info threads to see list of threads
// - watching the syslog with tail -f /var/log/syslog in conjunction w/ using
//   info threads command in gdb gives good idea of how this application gets
//   its threads schduled.
// - One thing I learned is that pthread_create and the underlying system call
//   clone() is blocking or must yield at some point. You can deduce this by
//   noticing that the main thread is still runnable and is blocked by a call
//   to clone while other threads assigned to core 0 are running and finishing,
//   loging a message in syslog.
// - Use thread <id> to switch debug context between threads.
//
// How code can be used for realtime services)
//----------------------------------------------------
// - Code can be used to indentify the system calls and boiler plate code
//   needed to lauch several threads with specified CPU affininty using the
//   real time SCHED_FIFO scheduler. 
//
//*****************************************************************************

#define _GNU_SOURCE
#include <pthread.h>   // pthread_*
#include <sched.h>     // sched_*
#include <syslog.h>    // syslog()
#include <stdlib.h>    // exit()
#include <stdio.h>     // printf()
#include <unistd.h>    // getpid()

#define NUM_THREADS 128
#define NUM_CPUS 4

void *counterThread(void *threadp)
{
    int sum = 0;
    int idx = *((int*) threadp);
    int i = 0;

    for(i = 0; i < idx; i++)
    {
        sum += i;
    }
    
    syslog(LOG_CRIT,"Thread idx=%d, sum[1...%d]=%d, Running on core : %d\n", 
           idx, idx, sum, sched_getcpu());
}

int main (int argc, char *argv[])
{
    // Allocate heap space for thread meta data
    int                idxs[NUM_THREADS] = {0};
    pthread_t          threads[NUM_THREADS] = {0};
    pthread_attr_t     thread_attrs[NUM_THREADS] = {0};

    // Temp variables to set pthread attributes
    struct sched_param fifo_param = {0};
    cpu_set_t cpuset = {0};

    // Set this process to use SCHED_FIFO so that main thread is RT on core 0
    // at max prio
    CPU_ZERO(&cpuset);
    CPU_SET(0, &cpuset);

    if(sched_setaffinity(getpid(), sizeof(cpu_set_t), &cpuset))
    {
        printf("Failed to set affinity of process, pls run as root\n");
        exit(1);
    }

    fifo_param.sched_priority = sched_get_priority_max(SCHED_FIFO);

    if(sched_setscheduler(getpid(), SCHED_FIFO, &fifo_param))
    {
        printf("Failed to set scheduler of process, pls run as root\n");
        exit(1);
    }
   
    int i;
    for(i = 0; i < NUM_THREADS; ++i)
    { 
        CPU_ZERO(&cpuset);
        CPU_SET(i % NUM_CPUS, &cpuset);

        idxs[i] = i;

        // Set each thread to run RT w/ SCHED_FIFO at max prio and on the CPU
        // of idx % NUMCPUS.
        pthread_attr_init(thread_attrs + i);
        pthread_attr_setinheritsched(thread_attrs + i, PTHREAD_EXPLICIT_SCHED);
        pthread_attr_setschedpolicy(thread_attrs + i, SCHED_FIFO);
        pthread_attr_setaffinity_np(thread_attrs + i, sizeof(cpu_set_t), &cpuset);
        pthread_attr_setschedparam(thread_attrs + i, &fifo_param);

        // Spawn each thread to execute the counterThread function
        pthread_create(threads + i,  
                       thread_attrs + i, 
                       counterThread,
                       idxs + i
                     );
    }

    // Block until all threads have finished executing
    for(i = 0; i < NUM_THREADS; i++)
    {
        pthread_join(threads[i], NULL);
    }
}
