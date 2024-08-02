.data
q: .asciiz "Enter number: "
q2: .asciiz "How many power?: "

.text
main:

    la      $a0, q
    jal     read_int
    move    $t0, $v0
    
    la      $a0, q
    jal     read_int
    move    $t1, $v0

    # Set up arguments for power function
    move    $a0, $t0
    move    $a1, $t1

    jal     power

    # Display result
    move    $a0, $v0
    li      $v0, 1
    syscall

    li      $v0, 10
    syscall

read_int:
    li      $v0, 4
    syscall
    
    li      $v0, 5
    syscall

    move    $v0, $v0
    jr      $ra

power:
    bne     $a1, $zero, recursion
    li      $v0, 1
    jr      $ra

recursion:

    # Store memory
    addi    $sp, $sp, -4    # Allocate space for one integer on the stack.
    sw      $ra, 0 ($sp)    # Store the address on the stack pointer.

    addi    $a1, $a1, -1

    jal     power           # Recursively call function

    mul     $v0, $a0, $v0

    # Restore memory
    lw      $ra, 0 ($sp)    # Restore the return address from the stack
    addi    $sp, $sp, 4     # Deallocate the memory on the stack

    # Return
    jr      $ra             # Return to the calling function