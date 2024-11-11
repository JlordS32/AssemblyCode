.data
query_msg: .asciiz "Enter n (2 - 50): "
error_msg: .asciiz "Error: Number not in range!\n"
fib_msg_1: .asciiz "Fib["
fib_msg_2: .asciiz "]: "
MAX: .word 50
MIN: .word 2
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
    mtc1    $v0, $f12
    mtc1    $v1, $f13

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

    li      $v0, 3              # print_double (syscall 3)
    syscall

    j       exit_program

fib:
    sub     $sp, $sp, 4         # Make space for five items
    sw      $ra, 0 ($sp)        # Save $ra 

    # Initialize base case
    li.d      $f14, 0.0         # Fib(0) or Fib(n-2) = 0
    li.d      $f16, 1.0         # Fib(1) or Fib(n-1) = 1

    # Initialise index counter
    move    $t0, $a0            # Load n to $t0

    # Decrement counter for n - 1 iterations
    sub     $t0, $t0, 1         # t0 = t0 - 1 (we need n-1 iterations)

fib_loop:
    # Perform F(n) = Fib(0) + Fib(1)
    add.d   $f18, $f14, $f16

    # Update Fib(n-2) and Fib(n-1) for the next Fib sequence.
    mov.d   $f14, $f16          # Fib(n-2)
    mov.d   $f16, $f18          # Fib(n-1)

    # Decrement counter
    sub     $t0, $t0, 1         # Decrement counter
    bgtz    $t0, fib_loop       # if t2 > 0, repeat loop
    mfc1    $v0, $f18           # Move result to $v0
    mfc1    $v1, $f19           # Move result to $v0

    lw      $ra, 0 ($sp)        # Restore $ra 
    add     $sp, $sp, 4         # Free stack

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

    lw      $s0, MIN
    blt     $v0, $s0, error     # Branch if less than MIN
    lw      $s1, MAX
    bgt     $v0, $s1, error     # Branch if greater than MAX

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
