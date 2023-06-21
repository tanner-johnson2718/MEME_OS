all: *.c
	$(CC) $(CFLAGS) -static -nostdlib  *.c -o syscall

clean:
	rm -f syscall
	rm -f *.o