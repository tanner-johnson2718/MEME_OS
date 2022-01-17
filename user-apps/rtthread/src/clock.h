#ifndef __MY_CLOCK_H_
#define __MY_CLOCK_H_

#include <time.h>

#define MY_CLOCK CLOCK_MONOTONIC_RAW
#define NSEC_PER_SEC (1000000000)

void tick(struct timespec *t1);
void tock(struct timespec *t1);

#endif