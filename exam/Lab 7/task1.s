.data
query_msg: .asciiz "Enter n (2 - 45): "
error_msg: .asciiz "Error: Number not in range!\n"
n: .word 0

.text
.globl main
main:
    # RESTORE ADDRESS
    # ----------------------
    addu    $s7, $0, $ra        # Restore address

    jal     query               # Call query()
    move    $s0, $v0            # Store
    sw      $s0, n              # Store value to n

    j       exit_program

query:
    sub     $sp, $sp, 12        # Make space for two items
    sw      $ra, 8 ($sp)        # Save $ra 
    sw      $s0, 4 ($sp)        # Save $s0 
    sw      $s1, 0 ($sp)        # Save $s1 

query_loop:
    li      $v0, 4              # print_str (syscall 4)
    la      $a0, query_msg      # Load 'query_msg' to print
    syscall

    li      $v0, 5              # read_int
    syscall

    li      $s0, 2
    blt     $v0, $s0, error     # Branch if less than 2
    li      $s1, 45
    bgt     $v0, $s1, error     # Branch if greater than 45

    lw      $s1, 0 ($sp)        # Restore $s1 
    lw      $s0, 4 ($sp)        # Restore $s0 
    lw      $ra, 8 ($sp)        # Restore $ra 
    add     $sp, $sp, 12        # Make space for two items

    jr      $ra 

error:
    li      $v0, 4              # print_str (syscall 4)
    la      $a0, error_msg      # Load 'error_msg' to print
    syscall

    j       query_loop          # Jump back to query

exit_program:
    # RESTORE ADDRESS
    # ----------------------
    addu    $ra, $0, $s7        # Restore address
    jr      $ra                 # Return to caller
    nop
