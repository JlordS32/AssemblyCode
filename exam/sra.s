.data
.align 0
msg: .ascii "JAGUAR"
num: .word 1, 2, 3, 4

.text
.globl main
main:
    

    li   $v0, 10         # Set system call for exit
    syscall
