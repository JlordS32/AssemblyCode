.data
r: .asciiz "The sum of is: "

.text
.globl main
main:
    # SAVE ADDRESS
    move        $s7, $ra

    # INITIALISING ARGS
    li          $a0, 5
    li          $a1, 10

    # CALL FUNCTION
    jal         add_n_square

    # PRINT SECTION
    move        $t0, $v0

    li          $v0, 4
    la          $a0, r
    syscall

    li          $v0, 1
    move        $a0, $t0    # 5 + 10 = 15 * 15 = 225
    syscall

    # RESTORE ADDRESS
    move        $ra, $s7

add_n_square:

    addi        $sp, $sp, -8    # Free up 8 bits of space (2 items)
    sw          $ra, 4($sp)     # Store return address
    sw          $s0, 0($sp)     # Save $s0

    # ARITHMETIC OPERATIONS
    add         $s0, $a0, $a1
    move        $a0, $s0
    
    jal         sqrt            # Call sqrt() function

    lw          $s0, 0($sp)     # Restore $s0
    lw          $ra, 4($sp)     # Restore return address

    addi        $sp, $sp, 8     # Clear the stack
    jr          $ra             # Return to the caller

sqrt:
    addi        $sp, $sp, -4    # Free up 4 bits of space
    sw          $ra, 0($sp)     # Store return address

    mul         $v0, $a0, $a0   # Multiply args by itself and store value at return value reg

    lw          $ra, 0($sp)     # Restore return address
    addi        $sp, $sp, 4     # Clear the stack
    jr          $ra             # Return to the caller

    