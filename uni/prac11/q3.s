.data
query_a:    .asciiz "\n\nEnter input for A: "
query_b:    .asciiz "Enter input for B: "
query_ci:   .asciiz "Enter input for Carry In: "
result:     .asciiz "Carry out: "
exit_msg:   .asciiz "\nPROGRAM TERMINATED...\n"
error_msg:  .asciiz "\nInput must be 0 or 1!\n"

.text
.globl main
main:
    # SAVE ADDRESS
    addu    $s7, $0, $ra        # Store main address at $s7

loop:  
    # QUERY: A
    # ------------------------
    la      $a0, query_a        # Load query_a
    jal     query               # Call query() to print
    add     $s0, $0, $v0        # Move input to $s0

    # QUERY: B
    # ------------------------
    la      $a0, query_b        # Load query_b
    jal     query               # Call query() to print
    add     $s1, $0, $v0        # Move input to $s1

    # QUERY: Carry In
    # ------------------------
    la      $a0, query_ci       # Load query_ci
    jal     query               # Call query() to print
    add     $s2, $0, $v0        # Move input to $s2

    # PERFORM OPERATION
    # ------------------------
    and     $t0, $s0, $s1       # a AND b
    and     $t1, $s0, $s2       # a AND Carry in
    and     $t2, $s1, $s2       # b AND Carry in
    or      $t0, $t0, $t1       # Perform $t0 OR $t1
    or      $t0, $t0, $t2       # Finally $t0 OR $t2

    # PRINT OUTPUT
    # ------------------------
    li      $v0, 4              # print_str (syscall 4)
    la      $a0, result         # Load result
    syscall

    li      $v0, 1              # print_int (syscall 1)
    move    $a0, $t0            # Copy $t0 to $a0
    syscall

    j       loop                # Repeat

query:
    # PRINT
    li      $v0, 4              # print_str (syscall 4)
    syscall

    # GET INPUT
    li      $v0, 5              # read_int (syscall 5)
    syscall

    # VALIDATE if within -1 and 1
    li      $t0, -1
    li      $t1, 1

    blt     $t1, $v0, query_error
    bgt     $t0, $v0, query_error

    beq     $t0, $v0, exit_program  # If input -1, exit.

    # RETURN    
    jal     $ra                 # Return to caller

query_error:
    sub     $sp, $sp, 4         # Make space for one item
    sw      $a0, 0 ($sp)        # Save $a0

    li      $v0, 4              # print_str (syscall 4)
    la      $a0, error_msg      # error_msg
    syscall

    lw      $a0, 0 ($sp)        # Restore $a0
    add     $sp, $sp, 4         # Free up space

    j       query               # Jump to query

exit_program:

    li      $v0, 4              # print_str (syscall 4)
    la      $a0, exit_msg       # Load exit_msg
    syscall

    # RESTORE ADDRESS AND EXIT
    addu    $ra, $0, $s7        # Restore main address
    jr      $ra                 # Return
    add     $0, $0, $0          # Nop