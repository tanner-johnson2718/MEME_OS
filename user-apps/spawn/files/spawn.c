// TODO, user app constantly changing so putting this off.

#define _GNU_SOURCE
#include <stdio.h>      // printf()
#include <unistd.h>     // fork(), pause(), sleep()
#include <stdlib.h>     // exit(), malloc()
#include <sys/wait.h>   // waitpit()
#include <fcntl.h>      // open()
#include <sched.h>      // clone()

// Static size variables
static int n_small = 1;
static int n_big = 0;
static int nbytes_small = 1024;
static int nbytes_big = 1024*1024;
static char pattern = 0xA5;
static int stack_size = 128*1024;

// Static ctl flow + test parameters
static int share_vm_space = 0;
static int parent_corrupt_heap = 0;

static int child_func(void* arg) {
   // Some dummy var on stack to get addr of stack
   int dummy;
   printf("\Child Stack Variable = %p\n", &dummy);

   // child context, sleep to give parent time to corrupt heap
   sleep(1);

   // Parse out the small data buffer on the heap and its size
   char* heap_buffer = (char*) arg;

   // check for heap consistency
   int i;
   int cont = 1;
   for(i = 0; i < nbytes_small; ++i){
      if(heap_buffer[i] != pattern){
         cont = 0;
         break;
      }
   }
   printf("Child Heap Consistency = %s\n", cont ? "TRUE" : "FALSE");

   pause();
   exit(0);
}

int main() {
   
   // Some dummy var on stack to get addr of stack
   int dummy;

   // creat an array of pointers to hold a sequence of allocs
   char* data_small[n_small];
   char* data_big[n_big];
   int i;
   
   printf("\nParent Stack Variable = %p\n", &dummy);

   // malloc big heap data (1 MiB)
   for(i = 0; i < n_big; ++i) {
      if( (data_big[i] = malloc(nbytes_big)) == NULL) {
         exit(1);
      }
      printf("data_big[%d] = %p\n", i,  data_big[i]);
   }

   // malloc small heap data (1 KiB)
   for(i = 0; i < n_small; ++i) {
      if( (data_small[i] = malloc(nbytes_small)) == NULL) {
         exit(1);
      }
      printf("data_small[%d] = %p\n", i, data_small[i]);
   }

   // Write this char data pattern to the parent heap data prior to the clone.
   // See if this data persits on the child.
   // Note just use the small heap buffer for convience
   for(i = 0; i < nbytes_small; ++i){
      data_small[0][i] = pattern;
   }

   // Use the clone system call to spawn a new process. Unlike fork(),
   // we have alloc a stack for the new process and we must give a func ptr for
   // the entrance point of execution of this new child process
   char* stack = calloc(sizeof(char), stack_size);
   if(stack == NULL) {
      exit(1);
   }
   printf("Child Stack = %p\n", stack);

   int flags = SIGCHLD;      // send signal to parent when child dies + share vm space
   if(share_vm_space){
      flags |= CLONE_VM;
   }
   pid_t ret = clone(child_func, stack + stack_size, flags, data_small[0]);
   if(ret == -1) {
      exit(1);
   }

   // Should be parent context only here

   // corrupt heap, should only mess with child if CLONE_VM is set in clone call
   if(parent_corrupt_heap){
      data_small[0][0] = 0xff;
   }

   // sleep to give child time to execute and ideally put shit on its stakc
   sleep(2);

   // check if child stack i.e. the on allocated in parents heap is corrupted
   int cont = 1;
   for(i = 0; i < stack_size; ++i){
      if(stack[i] != 0){
         cont = 0;
         break;
      }
   }
   printf("Child Stack consistency wrt Parent = %s\n", cont ? "TRUE" : "FALSE");

   // parent context
   wait(NULL);

   return 0;
}