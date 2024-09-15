    .data
query: .asciiz "Enter Fib(n): "
result_1: .asciiz "\nElement ["
result_2: .asciiz "] of Fibonacci string is: "
error: .asciiz "Number must be between 2 - 50!\n"
lower_range: .word 2
upper_range: .word 50

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
    move    $a0, $s1            # Load n to $a0 for fib function
    jal     fib                 # Call fib()
    
    # Load the the results
    mtc1    $v0, $f12           # Load the lower half to $f12
    mtc1    $v1, $f13           # Load the upper half to $f13

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

    # Print result
    li      $v0, 3              # print_double (system call 3)
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
    # Condition: Number between 2 - 50
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
    slt     $t0, $a0, 2             # Set $t0 to 1 if $a0 < 2
    bne     $t0, $0, fib_base       # If $a0 <= 1, jump to fib_base

    # Initialize base case
    li.d    $f14, 0.0               # Fib(0) = 0.0
    li.d    $f16, 1.0               # Fib(1) = 1.0

    # Initialize index counter
    move    $t2, $a0                # Load n to $t2
    sub     $t2, $t2, 1             # t2 = t2 - 1 (we need n-1 iterations)
fib_loop:
    # Calculate next Fibonacci number
    add.d   $f18, $f14, $f16        # $f18 = $f14 + $f16 (next Fibonacci number)

    # Update previous Fibonacci numbers
    mov.d   $f14, $f16              # $f14 = $f16 (lower half)
    mov.d   $f16, $f18              # $f16 = $f18 (upper half)

    # Decrement counter
    sub     $t2, $t2, 1             # t2 = t2 - 1
    bgtz    $t2, fib_loop           # if t2 > 0, repeat loop

    # Return the value
    mfc1    $v0, $f18               # Load lower half to $v1
    mfc1    $v1, $f19               # Load upper half to $v0
    
    jr      $ra                     # Return from the function
fib_base:
    # Base case
    move    $v0, $a0                # Return the input value in $v0
    move    $v1, $zero              # Set upper half to 0
    jr      $ra  

end_program:

    # RESTORE ADDRESS
    move    $ra, $s7
    jr      $ra
    add    $0, $0, $0