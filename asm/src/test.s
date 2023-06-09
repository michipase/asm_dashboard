.section .data
    message: .asciz "Hello, World!"

.section .text
.global _start

_start:
    # Access command-line arguments
    movl %esp, %ebp
    movl 8(%ebp), %ecx   # argv
    movl 12(%ebp), %ebx  # argc

    # Print command-line arguments
    movl $4, %eax
    movl $1, %edx
    leal message, %ecx
    movl $14, %edx
    int $0x80

    # Exit the program
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
