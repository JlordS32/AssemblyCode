.data
msg: .asciiz "The total sum of the array: "
array: .word 1, 2, 3, 4, 5
n: .word 5

.text
.globl main
main:
    addu    $s7, $0, $ra
    # Load address of the arra
    la      $s0, array

    # Load word
    lw      $s1, n

    # Initialisation
    li      $t0, 0      # Index
    li      $t1, 0      # Sum

loop:

    beq     $t0, $s1, end_loop

    lw      $t2, 0($s0)
    add     $t1, $t1, $t2
    addi    $s0, $s0, 4     # Move pointer to the next element.
    addi    $t0, $t0, 1

    j loop

end_loop:

    li      $v0, 4
    la      $a0, msg
    syscall

    li      $v0, 1
    move    $a0, $t1
    syscall

    addu    $ra, $0, $s7
    jr      $ra
    add     $0, $0, $0

