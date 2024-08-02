

        .data
nl:     .asciiz "\n"
        .text

main:
        li $t0, 2
        li $t1, 5
        li $t2, 7
        li $t3, 9

        li $v0, 1
        add $a0, $t0, $t1
        syscall

        li $v0, 4
        la $a0, nl
        syscall

        li $v0, 1
        add $a0, $t3, 1
        syscall

        li $v0, 4
        la $a0, nl
        syscall

        li $v0, 1
        mult $t1, $t1
        mflo $a0
        syscall

        li $v0, 10
        syscall

