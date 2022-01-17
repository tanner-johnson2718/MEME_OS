INCLUDE_DIRS = 
LIB_DIRS = 
CC=gcc

CDEFS=
CFLAGS= -O0 -g3 $(INCLUDE_DIRS) $(CDEFS)
LIBS= -lpthread -lrt

HFILES= 
CFILES= rtthread.c clock.c

SRCS= ${HFILES} ${CFILES}
OBJS= ${CFILES:.c=.o}

all:	rtthread

clean:
	-rm -f *.o *.d
	-rm -f rtthread 

rtthread: rtthread.o clock.o
	$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $@.o clock.o $(LIBS)

depend:

.c.o:
	$(CC) $(CFLAGS) -c $<
