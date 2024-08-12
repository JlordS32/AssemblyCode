
.text
main:

    li      $a0,    5
    li      $a1,    10
    li      $a2,    10
    li      $a3,    20

    jal     addition

    move    $a0, $v0
    li      $v0, 1
    syscall

    li      $v0, 10
    syscall

addition:

    addi    $sp,    $sp,    -12 # make room for 3 items

    sw      $t0,    8($sp)      # save $t0
    sw      $t1,    4($sp)      # save $t1
    sw      $s0,    0($sp)      # save $s0

    add     $t0,    $a0,    $a1 # $t0 gets g + h
    add     $t1,    $a2,    $a3 # $t1 gets i + j

    sub     $s0,    $t0,    $t1 # f gets (g+h) - (i+j)

    move    $v0,    $s0

    lw      $s0,    0($sp)      # restore $s0 for caller
    lw      $t1,    4($sp)      # restore $t1 for caller
    lw      $t0,    8($sp)      # restore $t0 for caller

    addi    $sp,    $sp,    12  # shrink stack by 3 items

    jr      $ra                 # jump back to caller