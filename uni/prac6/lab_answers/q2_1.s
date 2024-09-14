    .data
query: .asciiz "Enter Fib(n): "
result_1: .asciiz "\nElement ["
result_2: .asciiz "] of Fibonacci string is: "
error: .asciiz "Number must be between 2 - 45!\n"
lower_range: .word 2
upper_range: .word 45

    .text
    .globl main
main:
    # SAVE ADDRESS
    # ----------------
    move    $s7, $ra

    jal     input

    # Copy value over to $s1
    move    $s1, $v0            # n = $v0

    # Call fib function
    move    $a0, $s1          # Load n to $a0 for fib function
    jal     fib               # Call fib()
    move    $s0, $v0          # result = fib(n)

    # OUTPUT RESULTS
    # ----------------
    # Print value
    li      $v0, 4              # print_str (system call 4)
    la      $a0, result_1
    syscall

    li      $v0, 1              # print_int (system call 1)
    move    $a0, $s1
    syscall

    li      $v0, 4              # print_str (system call 4)
    la      $a0, result_2
    syscall

    li      $v0, 1              # print_int (system call 1)
    move    $a0, $s0
    syscall
    
    # END 
    # ----------------
    j       end_program

# INPUT FUNCTION
input:
    # INPUT USER
    # ----------------
    li      $v0, 4              # print_str (system call 4)
    la      $a0, query
    syscall

    # Read integer
    li      $v0, 5              # read_int (system call 5)
    syscall
    
    # CHECK CONDITION
    # ----------------
    # Condition: Number between 2 - 45
    lw      $t1, lower_range
    lw      $t2, upper_range
    slt     $t0, $v0, $t1
    bne     $t0, $0, input_error        # Loop back
    sgt     $t0, $v0, $t2
    bne     $t0, $0, input_error        # Loop back

    # Return to caller
    jr      $ra

input_error:
    
    li      $v0, 4
    la      $a0, error
    syscall

    j       input

# FIBONACCI FUNCTION
    .globl fib
fib:
    # Check if n < 2
    slt     $t0, $a0, 2
    bne     $t0, $0, fib_base   # if $a0 <= 1, jump to fib_base

    # Initialize base case
    li      $t0, 0              # Fib(0) = 0
    li      $t1, 1              # Fib(1) = 1

    # Initialise index counter
    move    $t2, $a0            # Load n to $t2

    # Decrement counter for n - 1 iterations
    sub     $t2, $t2, 1         # t2 = t2 - 1 (we need n-1 iterations)

fib_loop:
    # Calculate next Fibonacci number
    add     $t3, $t0, $t1       # t3 = t0 + t1 (next Fibonacci number)
    move    $t0, $t1            # t0 = t1
    move    $t1, $t3            # t1 = t3

    # Decrement counter
    sub     $t2, $t2, 1         # t2 = t2 - 1
    bgtz    $t2, fib_loop       # if t2 > 0, repeat loop

    # Result is in t1
    move    $v0, $t1            # Move result to $v0
    jr      $ra

fib_base:
    # Base case
    move    $v0, $a0
    jr      $ra

end_program:

    # RESTORE ADDRESS
    move    $ra, $s7
    jr      $ra
    add    $0, $0, $0