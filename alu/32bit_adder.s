.data
input_A: .asciiz "\nEnter number for A: "
input_B: .asciiz "\nEnter number for B: "
error_msg: .asciiz "\NUMBER OUT OF RANGE!\n"
number_bit: .word 32

.text
.globl main
main:
    # Save main address
    addu    $s7, $0, $ra

    # Query for A
    la      $a0, input_A            # Get input A
    jal     query                   # Call function
    move    $t0, $v0

    # Query for B
    la      $a0, input_B            # Get input B
    jal     query                   # Call function
    move    $t1, $v0

    # Load adder
    move    $a0, $t0
    move    $a1, $t1
    jal     bit_adder
    move    $t0, $v0

    li      $v0, 1
    move    $a0, $t0
    syscall

    j       exit_program

bit_adder:
    # Save items into the stack
    sub     $sp, $sp, 20
    sw      $ra, 0 ($sp)
    sw      $s0, 4 ($sp)
    sw      $s1, 8 ($sp)
    sw      $s2, 12 ($sp)
    sw      $s3, 16 ($sp)

    # Initialize registers
    addu    $s0, $0, $a0            # A
    addu    $s1, $0, $a1            # B
    addi    $s2, 0                  # Result register
    addi    $s3, 0                  # Carry register (Carry_in and Carry_out)
    li      $t0, 0                  # Bit position counter (i = 0)

bit_loop:
    # Check if all bits have been processed
    lw      $t9, number_bit
    bge     $t0, $t9, end_addition

    # Extract A_i
    srlv    $t1, $s0, $t0           # Shift A right by i bits
    andi    $t1, $t1, 0x1           # A_i = (A >> i) & 1

    # Extract B_i
    srlv    $t2, $s1, $t0           # Shift B right by i bits
    andi    $t2, $t2, 0x1           # B_i = (B >> i) & 1

full_adder:
    # GET: Sum_i
    xor     $t3, $t1, $t2           # $t3 = A_i XOR B_i
    xor     $t3, $t3, $s3           # $t3 = $t3 XOR Carry_in

    # GET: Carry_out
    and     $t4, $t1, $t2           # A_i AND B_i
    xor     $t5, $t1, $t2           # A_i XOR B_i
    and     $t6, $t5, $s3           # (A_i XOR B_i) AND Carry_in
    or      $s3, $t4, $t6           # Update Carry_in

    # Set Sum_i at bit position i in result
    sllv    $t4, $t3, $t0           # Shift Sum_i left by i bits
    or      $s2, $s2, $t4           # $s2 |= Sum_i << i

    # Increment bit position counter (i++)
    addi    $t0, $t0, 1
    j       bit_loop

end_addition:
    addu    $v0, $0, $s2            # Copy result value to return

    # Restore callee-saved registers and return address
    lw      $ra, 0($sp)
    lw      $s0, 4($sp)
    lw      $s1, 8($sp)
    lw      $s2, 12($sp)
    lw      $s3, 16($sp)
    addi    $sp, $sp, 20

    jr      $ra                     # Return to main

query: 
    # Make a space into the stack
    sub     $sp, $sp, 12
    sw      $ra, 0 ($sp)
    sw      $s0, 4 ($sp)
    sw      $s1, 8 ($sp)

    li      $v0, 4
    syscall

    li      $v0, 5
    syscall

    # VALIDATE IF NUMBER IN RANGE
    lw      $s1, number_bit
    addi    $s1, $s1, -1
    li      $s0, 1
    sllv    $s0, $s0, $s1           # Move bit to n - 1
    bgt     $v0, $s0, query_error   # Branch if number greatan 128

    lw      $s1, 8 ($sp)
    lw      $s0, 4 ($sp)
    lw      $ra, 0 ($sp)
    add     $sp, $sp, 8

    jr      $ra

query_error:
    sub     $sp, $sp, 4
    sw      $a0, 0 ($sp)

    li      $v0, 4
    la      $a0, error_msg
    syscall

    lw      $a0, 0 ($sp)
    add     $sp, $sp, 4

    j       query

exit_program:
    addu    $ra, $0, $s7
    jr      $ra
    nop