
static void my_write(int fd, char* buf, long len)
{
    asm("mov $1, %rax\n"
        "syscall\n");
}

void my_puts(char* str, long len)
{
    my_write(1, str, len);
}


void _start()
{
    my_puts("Shalome\n", 8);
}