.data
q: .asciiz "Number: "
r: .asciiz "Factorial: "
exclamation_marks: .asciiz "!"

.text

main:
    li      $v0, 4
    la      $a0, q
    syscall

    li      $v0, 5
    syscall
    move    $a0, $v0
    
    jal     fact

    move    $s0, $v0

    li      $v0, 4
    la      $a0, r
    syscall

    li      $v0, 1
    move    $a0, $s0
    syscall

    li      $v0, 4
    la      $a0, exclamation_marks
    syscall

    li      $v0, 10
    syscall

fact:

    beqz    $a0, end
    
    # Initialisation
    li      $v0, 1
    li      $t0, 1

fact_loop:

    bgt     $t0, $a0, end_fact_loop

    mul     $v0, $v0, $t0

    addi    $t0, $t0, 1

    j       fact_loop

end_fact_loop:
    jr      $ra

end:
    li      $v0, 1
    jr      $ra

