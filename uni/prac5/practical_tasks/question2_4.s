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

    # Loop setup
    # To be reused later in print_array
    li      $t0, 0          # Index
    lw      $t1, N          # Value of N

    # Start filling arrays
    jal     fill_array      # Call fill_array procedure

    # Print array P
    li      $t0, 0          # Reset index
    la      $a0, P
    la      $a1, P_letter
    jal     print_array

    # Print array Q
    li      $t0, 0          # Reset index
    la      $a0, Q
    la      $a1, Q_letter
    jal     print_array

    j       end_program

fill_array:
    beq     $t0, $t1, end_loop 
    # PRINTING QUERY
    # -------------------
    # Print query message
    li      $v0, 4
    la      $a0, P_query
    syscall

    # Start bracket
    la      $a0, start_bracket
    syscall 

    # Current index
    li      $v0, 1
    move    $a0, $t0
    syscall

    # End bracket
    li      $v0, 4
    la      $a0, end_bracket
    syscall

    # GET USER INPUT
    # ------------------
    li      $v0, 5
    syscall

    # LOAD ARRAY ADDRESS
    # ------------------
    la      $s0, P
    la      $s1, Q

    # FILL ARRAY
    # -----------------
    sll     $t2, $t0, 2         # Get address offset
    add     $t3, $t2, $s0       # Offset array P
    add     $t4, $t2, $s1       # Offset array Q

    # Store the value into the current index
    sw      $v0, 0($t3)            
    sw      $v0, 0($t4)

    # END LOOP
    # -----------------
    # Increment index
    addi    $t0, $t0, 1

    # Loop
    j       fill_array

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

    li      $v0, 4
    move    $a0, $s1
    syscall

    la      $a0, start_bracket
    syscall

    li      $v0, 1
    move    $a0, $t0
    syscall

    li      $v0, 4
    la      $a0, end_bracket
    syscall

    li      $v0, 1
    move    $a0, $t4
    syscall

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

query_user:
    # Print query message
    li      $v0, 4
    la      $a0, N_query
    syscall

    # Catch user input
    li      $v0, 5
    syscall

    jr      $ra

end_program:

    # RESTORE ADDRESS
    addu    $ra, $0, $s7
    jr      $ra
    add     $0, $0, $0