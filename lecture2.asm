.data
endl: .asciiz "\n"

.text
main:
    li      $t0, 1

loop:
    li      $v0, 1
    move    $a0, $t0
    syscall

    li      $v0, 4
    la      $a0, endl
    syscall

    addi    $t0, $t0, 1
    li      $t1, 5
    blt     $t0, $t1, loop
    syscall

    li      $v0, 10
    syscall
