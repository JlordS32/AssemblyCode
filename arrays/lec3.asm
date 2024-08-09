        .data
array:  .word 10, 20, 30, 40, 50
msg:    .asciiz "Address at: "
value:  .asciiz "Value is: "
endl:   .asciiz "\n"

        .text
main:
    move    $s7, $ra

    # Store array in $t0
    la      $t0, array

    # Call print_address function
    jal     print_address

    # Counter variable
    li      $t1, 0
    li      $t2, 5

loop:

    beq     $t1, $t2, exit_code
    li      $t3, 0
    li      $t4, 4

    mult    $t4, $t1
    mflo    $t3

    lw      $t0, array($t3)

    li      $v0, 4
    la      $a0, value
    syscall

    li      $v0, 1
    move    $a0, $t0
    syscall

    jal     new_line

    addi    $t1, 1

    j       loop

new_line:

    li      $v0, 4
    la      $a0, endl
    syscall

    jr      $ra

print_address:

    li      $v0, 4
    la      $a0, msg
    syscall

    li      $v0, 1
    move    $a0, $t0
    syscall

    li      $v0, 4
    la      $a0, endl
    syscall

    jr      $ra

exit_code:

    move    $ra, $s7
    jr      $ra