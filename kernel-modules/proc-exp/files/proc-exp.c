#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/sched.h>           // task_struct
#include <linux/sched/signal.h>    // for_each_process

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("Process Explorer from kernel space");
MODULE_AUTHOR("me");
MODULE_VERSION("0.1");

// Routine to basically does what ps linux command does, but 
// has direct access to the task_struct and thus can grab kernel / sched info
// on a proc. 
static void kmod_ps(void) {
    // first lets pull out the master tasks vector from the kernel
    struct task_struct* task;

    // Use kernel macro for iterating processes
    for_each_process(task) {

        // get state
        long state = task->state;

        // get PID
        pid_t pid = task->pid;

        // Get EXE name
        char* comm;
        comm = task->comm;

        // Get CPU assignment
        int on_cpu = -1;
        int cpu = -1;

        #ifdef CONFIG_SMP
        on_cpu = task->on_cpu;
        cpu = task->cpu;
        #endif

        // Kerenel Thread?? If NULL then kernel thread
        struct mm_struct* mm = task->mm;

        // TODO
        // Get Thread info
        // CPU Usage counters
        // Priority counters

        // Output to terminal process terminal
        pr_info("PID = %u EXE = %s\n   STATE = %u\n   CPU = %d\n   ON_CPU = %d\n   MM = %p\n", pid, comm, state, cpu, on_cpu, mm);

    }
}

static void kexit(void) {
    return;
}

// INIT module. 
static int kinit(void) {
    
    // int error = 0;

    // pr_debug("Module initialized successfully \n");

    // example_kobject = kobject_create_and_add("kobject_example", kernel_kobj);
    // if(!example_kobject) {
    //     return -ENOMEM;
    // }

    // error = sysfs_create_file(example_kobject, &foo_attribute.attr);
    // if (error) {
    //     pr_debug("failed to create the foo file in /sys/kernel/kobject_example \n");
    // }

    return 0;
}

module_init(kinit);
module_exit(kexit);
