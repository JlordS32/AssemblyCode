.data
N_query: .asciiz "Enter a digit (1-9): "
error: .asciiz "Number must be between 1 - 9!\n"
P_query: .asciiz "Enter value for "
Q_query: .asciiz "Enter value for "
P_letter: .asciiz "P"
Q_letter: .asciiz "Q"
endl: .asciiz "\n"
start_bracket: .asciiz "["
end_bracket: .asciiz "]: "

P: .word 0, 0, 0, 0, 0, 0, 0, 0, 0
Q: .word 0, 0, 0, 0, 0, 0, 0, 0, 0
N: .word 0

.text
.globl main
main:
    # SAVE ADDRESS
    addu    $s7, $0, $ra

    jal     query_user      # Call query_user procedure
    sw      $v0, N          # Store input to N

    # LOOP SETUP
    # -----------
    # To be reused later in print_array
    li      $t0, 0          # Index
    lw      $t1, N          # Value of N

    # PROCEDURE CALLS
    # ---------------
    # Fill up array for P
    jal     fill_array      # fill_aray for P

    # fILL UP ARRAY for Q
    li      $t0, 0          # Index
    la      $a0, P          # Load the address of P
    jal     accumulate

    # Print array P
    li      $t0, 0          # Reset index
    la      $a0, P          # Load the P address into the first argument
    la      $a1, P_letter   # Load letter into second argument
    jal     print_array     # Jump to print_array procedure

    # Print array Q
    li      $t0, 0          # Reset index
    la      $a0, Q          # Load the Q address into the first argument
    la      $a1, Q_letter   # Load letter into second argument
    jal     print_array     # Jump to print_array procedure

    # END
    # ------------
    j       end_program

# Procedure: query_user
# Purpose: Get the number of elements (N) from the user
query_user:
    li      $t1, 9

    # Print query message
    li      $v0, 4
    la      $a0, N_query
    syscall

    # Catch user input
    li      $v0, 5
    syscall

    blez    $v0, while_not_in_range
    bgt     $v0, $t1, while_not_in_range

    jr      $ra

while_not_in_range:

    li      $v0, 4
    la      $a0, error
    syscall

    j       query_user

# Procedure: fill_array
# Purpose: Fill arrays P and Q based on user input
fill_array:
    beq     $t0, $t1, end_loop 
    # PRINTING QUERY
    # -------------------
    # Print query message
    li      $v0, 4
    la      $a0, P_query
    syscall

    # Print: Start bracket
    la      $a0, start_bracket
    syscall 

    # Print: Current index
    li      $v0, 1
    move    $a0, $t0
    syscall

    # Print: End bracket
    li      $v0, 4
    la      $a0, end_bracket
    syscall

    # GET USER INPUT
    # ------------------
    li      $v0, 5
    syscall

    # LOAD ARRAY ADDRESS
    # ------------------
    la      $s0, P              # Load the addres of P

    # FILL ARRAY
    # -----------------
    sll     $t2, $t0, 2         # $t2 = index * 4 (word size)
    add     $t3, $t2, $s0       # $t3 = address of P[index]

    # Store the value into the current index
    sw      $v0, 0($t3)            

    # END LOOP
    # -----------------
    addi    $t0, $t0, 1         # Increment index

    # Loop
    j       fill_array

accumulate:
    move    $s0, $a0            # Load address of P into $s0
    la      $s1, Q              # Load address of Q into $s1

    li      $t0, 0              # Initialize index to 0
    li      $t6, 0              # Initialize accumulator to 0

accumulate_loop:
    beq     $t0, $t1, end_loop  # If index equals N, end loop
    
    # Calculate offsets for P and Q
    sll     $t2, $t0, 2         # $t2 = index * 4 (word size)
    add     $t3, $s0, $t2       # $t3 = address of P[index]
    add     $t4, $s1, $t2       # $t4 = address of Q[index]

    lw      $t5, 0($t3)         # Load P[index] into $t5

    # Accumulate the value from P into $t6
    add     $t6, $t6, $t5       # Accumulate P[index] into $t6
    sw      $t6, 0($t4)         # Store the accumulated value into Q[index]

    addi    $t0, $t0, 1         # Increment index

    j       accumulate_loop     # Repeat loop

# Procedure: print_array
# Purpose: Print the contents of an array
print_array:
    move    $s0, $a0            # Copy array address to $s0
    move    $s1, $a1            # Copy letter to $s1

    # Print a new line
    li      $v0, 4
    la      $a0, endl
    syscall

print_start_loop:

    beq     $t0, $t1, end_loop

    sll     $t2, $t0, 2         # Get address offset
    add     $t3, $t2, $s0       # Move pointer to next element

    # Load value of array[i]
    lw      $t4, 0($t3)

    # PRINTING VALUE
    # -----------------------

    # Print: LETTER
    li      $v0, 4
    move    $a0, $s1
    syscall

    # Print: Start bracket
    la      $a0, start_bracket
    syscall

    # Print: Index
    li      $v0, 1
    move    $a0, $t0
    syscall

    # Print: End bracket
    li      $v0, 4
    la      $a0, end_bracket
    syscall

    # Print: the actual value at $t4
    li      $v0, 1
    move    $a0, $t4
    syscall

    # Print: Newline
    li      $v0, 4
    la      $a0, endl
    syscall

    # END LOOP
    # -----------------
    # Increment index
    addi    $t0, $t0, 1

    # Loop
    j       print_start_loop

end_loop:
    # Jump back to caller
    jr      $ra

end_program:

    # RESTORE ADDRESS
    addu    $ra, $0, $s7
    jr      $ra
    add     $0, $0, $0