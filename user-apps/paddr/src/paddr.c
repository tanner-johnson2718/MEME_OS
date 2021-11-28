// User App to read /proc/[pid]/pagemap attr of the procfs system and output
// this info to console in a user readable format. Expects pid as one and only
// arg.

#include <stdio.h>          // printf()
#include <fcntl.h>          // open()
#include <stdio.h>          // atoi(), sprintf()
#include <linux/limits.h>   // PATH_MAX
#include <fcntl.h>          // open()
#include <stdlib.h>         // strtoul()
#include <unistd.h>         // _SC_PAGE_SIZE, sysconf()
#include <stdint.h>         // uint8_t, etc

int main(int argc, char** argv) {

   // Local variables
   int pid;
   int fd;
   char path[PATH_MAX];
   unsigned long vaddr;
   unsigned long vpn;

   // Parse args
   if(argc != 3){
      printf("Usage) %s <pid> <virtual_addr in hex>\n", argv[0]);
      return 1;
   }

   // atoi rets 0 on error, but 0 shouldn't be passed anyways. this checks that
   // input is valid
   pid = atoi(argv[1]);        
   if(pid <= 0){
      printf("error parsing pid, check inputs\n");
      return 1;
   }

   vaddr = strtoul(argv[2], NULL, 16);
   vpn = vaddr / sysconf(_SC_PAGE_SIZE);

   // Construct string that contains path to relavent pagemap files
   sprintf(path, "/proc/%d/pagemap", pid);

   // open pagemap file
   fd = open(path, O_RDONLY);

   // seek and read the appropiate vpn's physical address
   int nread = 0;
   uint64_t data;
   int ret;
   while (nread < sizeof(data)) {
      ret = pread(fd, ((uint8_t*)&data) + nread, sizeof(data) - nread, vpn * sizeof(data) + nread);
      nread += ret;
      if (ret <= 0) {
         return 1;
      }
   }
   
   // Parse out the attributes contained in the data
   unsigned long pfn = data & (((uint64_t)1 << 55) - 1);
   int soft_dirty = (data >> 55) & 1;
   int file_page = (data >> 61) & 1;
   int swapped = (data >> 62) & 1;
   int present = (data >> 63) & 1;

   // output to console
   printf("Phy Addr   = %p\n", (void *) pfn);
   printf("Soft Dirty = %d\n", soft_dirty);
   printf("File Page  = %d\n", file_page);
   printf("Swapped    = %d\n", swapped);
   printf("Present    = %d\n", present);

   return 0;
}