#include "clock.h"
#include <time.h>

//*****************************************************************************
// Private helper
//*****************************************************************************

// Sum t2 into t1
void sum(struct timespec *t1, struct timespec *t2)
{
    t1->tv_nsec += t2->tv_nsec;   // Cannot overflow, if valid time to begin w.

    if(t1->tv_nsec >= NSEC_PER_SEC)
    {
        t1->tv_sec  += 1;    // If valid time, then will only ever add 1 to secs
        t1->tv_nsec -= NSEC_PER_SEC;
    }
}

// Return one if t1 > t2. Else 0.
int greater(struct timespec *t1, struct timespec *t2)
{
    // More seconds in t1
    if(t1->tv_sec > t2->tv_sec)
    {
        return 1;
    }

    // More seconds in t2
     if(t1->tv_sec < t2->tv_sec)
    {
        return 0;
    }

    // Only here if same number of seconds
    return (t1->tv_nsec > t2->tv_nsec);
}

//*****************************************************************************
// Public
//*****************************************************************************

void tick(struct timespec *t1)
{
    clock_gettime(MY_CLOCK, t1);
}

void tock(struct timespec *t1)
{
    struct timespec _t2;
    struct timespec *t2 = &_t2;
    clock_gettime(MY_CLOCK, t2);

    t2->tv_sec  -= t1->tv_sec;   // strictly increasing so good
    t2->tv_nsec -= t1->tv_nsec;  // Could be negative, can't overflow

    // copy over
    t1->tv_sec = t2->tv_sec;
    t1->tv_nsec = t2->tv_nsec;

    if(t1->tv_nsec < 0)
    {
        t1->tv_nsec += NSEC_PER_SEC;
        t1->tv_sec -= 1;
    }
}