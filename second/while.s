.data
i: .word 0
endl: .asciiz "\n"
done: .asciiz "\nDONE !"

.text
.globl main
main:
    addu    $s7, $0, $ra

    lw      $t2, i
    li      $t3, 10

loop:
    slt     $s0, $t2, $t3
    bne     $s0, $0, calc_update
    j       end_loop

calc_update:
    li      $v0, 1
    move    $a0, $t2
    syscall

    li      $v0, 4
    la      $a0, endl
    syscall

    addi    $t2, $t2, 1
    j       loop

end_loop:
    li      $v0, 4
    la      $a0, done
    syscall

    addu    $ra, $0, $s7
    jr      $ra
    add     $0, $0, $0