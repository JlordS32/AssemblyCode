.data
query_msg: .asciiz "Enter n (2 - 45): "
error_msg: .asciiz "Error: Number not in range!\n"
fib_msg_1: .asciiz "Fib["
fib_msg_2: .asciiz "]: "
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

    # CALLING FIB() 
    # ----------------------
    lw      $a0, n              # Load value in 'n' as param.
    jal     fib                 # Call fib
    move    $s1, $v0

    # PRINT
    # ----------------------

    li      $v0, 4
    la      $a0, fib_msg_1
    syscall

    li      $v0, 1
    move    $a0, $s0
    syscall

    li      $v0, 4
    la      $a0, fib_msg_2
    syscall

    li      $v0, 1
    move    $a0, $s1
    syscall

    j       exit_program

fib:
    sub     $sp, $sp, 16        # Make space for five items
    sw      $ra, 12 ($sp)       # Save $ra 
    sw      $s0, 8 ($sp)        # Save $s0 
    sw      $s1, 4 ($sp)        # Save $s1 
    sw      $s2, 0 ($sp)        # Save $s1

    # Initialize base case
    li      $s0, 0              # Fib(0) or Fib(n-2) = 0
    li      $s1, 1              # Fib(1) or Fib(n-1) = 1

    # Initialise index counter
    move    $t0, $a0            # Load n to $t0

    # Decrement counter for n - 1 iterations
    sub     $t0, $t0, 1         # t0 = t0 - 1 (we need n-1 iterations)

fib_loop:
    # Perform F(n) = Fib(0) + Fib(1)
    add     $s2, $s0, $s1       

    # Update Fib(n-2) and Fib(n-1) for the next Fib sequence.
    move    $s0, $s1            # Fib(n-2)
    move    $s1, $s2            # Fib(n-1)

    # Decrement counter
    sub     $t0, $t0, 1         # Decrement counter
    bgtz    $t0, fib_loop       # if t2 > 0, repeat loop
    move    $v0, $s1            # Move result to $v0

    lw      $s2, 0 ($sp)        # Restore $s1
    lw      $s1, 4 ($sp)        # Restore $s1 
    lw      $s0, 8 ($sp)        # Restore $s0 
    lw      $ra, 12 ($sp)       # Restore $ra 
    add     $sp, $sp, 16        # Free stack

    # Result is in Fib (n - 1)
    jr      $ra

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
    add     $sp, $sp, 12        # Free stack

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
