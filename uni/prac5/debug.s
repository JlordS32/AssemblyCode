
    .data
Alen:    .word  10
Astart:  .word  4, -2, 5, -1, 0, 6, -7, 1, 0, -10
Psum:    .word  0

    .text
main:
    addu    $s7, $0, $ra      # save the return address in a global register

    lw      $t0, Alen           # load length    
    add     $t0, $t0, $t0      # double
    add     $t0, $t0, $t0      # quadruple
    addi    $t0, $t0, -4      # back off one word  
    li      $t1, 0              # clear $t1    
    li      $t2, 0              # clear $t2

    li      $v0, 1
    move      $a0, $t0
    syscall

    addu    $ra, $0, $s7
    jr      $ra