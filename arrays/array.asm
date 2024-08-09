.data
array:  .word   10, 20, 30, 40, 50

.text
main:

    move    $t0,    $zero

loop:
    add     $t1,    $t0,    $t0     # $t1 = 2i
    add     $t1,    $t1,    $t1     # $t1 = 4i

    add     $t2,    $a0,    $t1     # $t2 = array[i]

    sw      $zero,  0 ($t2)         # array[i] = 0
    addi    $t0,    $t0,    1       # i = i + 1
    slt     $t3,    $t0,    $a1     # $t3 = (i < size0)

    bne     $t3,    $zero,  loop

end_loop:

    li      $v0,    10
    syscall