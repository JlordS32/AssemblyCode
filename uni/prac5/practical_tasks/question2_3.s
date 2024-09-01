.data
N_query: .asciiz "Enter a digit (1-9): "
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
    # Start filling arrays
    jal     fill_array      # Call fill_array procedure

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
    # Print query message
    li      $v0, 4
    la      $a0, N_query
    syscall

    # Catch user input
    li      $v0, 5
    syscall

    jr      $ra

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
    la      $s1, Q              # load the address of Q

    # FILL ARRAY
    # -----------------
    sll     $t2, $t0, 2         # Get address offset
    add     $t3, $t2, $s0       # Offsetted array P
    add     $t4, $t2, $s1       # Offsetted array Q

    # Store the value into the current index
    sw      $v0, 0($t3)            
    sw      $v0, 0($t4)

    # END LOOP
    # -----------------
    # Increment index
    addi    $t0, $t0, 1

    # Loop
    j       fill_array

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