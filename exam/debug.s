

.text
.globl main
main:
    addu    $s7, $0, $ra

    li      $t0, 4

    sll     $t0, $t0, 2

    li      $v0, 1
    move    $a0, $t0
    syscall

    addu    $ra, $0, $s7
    jr      $ra
    addu    $0, $0, $0