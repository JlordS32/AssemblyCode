        .data
array:  .word 10, 20, 30, 40, 50, 0 # Null-terminated array

        .text
main:
    move    $s7, $ra
    la      $t0, array

    # Initialise index counter
    li      $t1, 0

loop:

    lw      $t2, 0($t0)
    beq     $t2, $zero, end_loop

    addi    $t1, $t1, 1             # Increment counter
    
    addi    $t0, $t0, 4 
    j       loop         

end_loop:
    move    $ra, $s7
    jr      $ra