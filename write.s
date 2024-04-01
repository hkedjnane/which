global _start

section .data
    msg db "Hello, world!", 0x0a
    len equ $ - msg

section .text
_start:
    lea rax, 4
    lea rdi, 1
    lea rsi, msg
    lea rdx, len
    syscall
    lea rax, 1
    lea rdi, 0
    syscall
