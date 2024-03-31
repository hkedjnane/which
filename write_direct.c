#include <unistd.h>

int main()
{
    char str[] = "Hello World!\n";
    size_t len = 13;
    int write_syscall = 4;
    ssize_t ret;
    asm volatile
    (
        "syscall"
        : "=a" (ret)
        : "0"(write_syscall), "D"(STDOUT_FILENO), "S"(str), "d"(len)
        : "rcx", "r11", "memory"
    );
}
