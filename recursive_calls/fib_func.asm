.data
endl: .asciiz "\n"


.text
fibonacci:

    li      $t0, 1
    bgt     $a0, $t0, recurse

    bne     $a0, $zero, base_case
    li      $v0, 0
    jr      $ra

base_case:
    li      $v0, 1
    jr      $ra

recurse:
    addi    $sp, $sp, -12
    sw      $ra, 8 ($sp)
    sw      $a0, 4 ($sp)

    addi    $a0, $a0, -1
    jal     fibonacci
    sw      $v0, 0 ($sp)

    lw      $a0, 4 ($sp)
    addi    $a0, $a0, -2
    jal     fibonacci

    lw      $t0, 0 ($sp)
    add     $v0, $t0, $v0

    lw      $ra, 8 ($sp)
    addi    $sp, $sp, 12
    jr      $ra

main:

    li      $t1, 0
    li      $t2, 10
