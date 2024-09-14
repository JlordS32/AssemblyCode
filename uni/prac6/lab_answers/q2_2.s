.data
query:      .asciiz "Enter Fib(n): "
result_1:   .asciiz "\nElement ["
result_2:   .asciiz "] of Fibonacci string is: "
error:      .asciiz "Number must be between 2 - 50!\n"
lower_range: .word 2
upper_range: .word 50

.text
.globl main
main:
    # SAVE RETURN ADDRESS
    # ------------------
    move        $s7, $ra

    # INPUT USER
    # ------------------
    jal         input

    # Copy value over to $s1
    move        $s1, $v0            # n = $v0

    # Call fib function
    move        $a0, $s1            # Load n to $a0 for fib function
    jal         fib                 # Call fib()
    mov.d       $f2, $f0            # result = fib(n) in double-precision

    # OUTPUT RESULTS
    # ----------------
    # Print value
    li          $v0, 4              # print_str (system call 4)
    la          $a0, result_1
    syscall

    li          $v0, 1              # print_int (system call 1)
    move        $a0, $s1
    syscall

    li          $v0, 4              # print_str (system call 4)
    la          $a0, result_2
    syscall

    # Print double-precision result
    li          $v0, 3              # print_double (system call 3)
    mov.d       $f12, $f2           # Move result to $f12 for printing (f12 and f13)
    syscall

    # END 
    j           end_program

# INPUT FUNCTION
input:
    # INPUT USER
    # ----------------
    li          $v0, 4              # print_str (system call 4)
    la          $a0, query
    syscall

    # Read integer
    li          $v0, 5              # read_int (system call 5)
    syscall
    
    # CHECK CONDITION
    # -----------------
    # Condition: Number between 2 - 50
    lw          $t1, lower_range
    lw          $t2, upper_range
    slt         $t0, $v0, $t1
    bne         $t0, $0, input_error        # Loop back
    sgt         $t0, $v0, $t2
    bne         $t0, $0, input_error        # Loop back

    # Return to caller
    jr          $ra

input_error:
    li          $v0, 4
    la          $a0, error
    syscall

    j           input

# FIBONACCI FUNCTION
.globl fib
fib:
    # Check if n < 2
    slt         $t0, $a0, 2
    bne         $t0, $0, fib_base   # if $a0 <= 1, jump to fib_base

    # Initialize base case
    li.d        $f0, 0.0            # Fib(0) = 0.0
    li.d        $f2, 1.0            # Fib(1) = 1.0 (f2, f3 for double-precision)

    # Initialise index counter
    move        $t2, $a0            # Load n to $t2

    # Decrement counter for n - 1 iterations
    sub         $t2, $t2, 1         # t2 = t2 - 1 (we need n-1 iterations)

fib_loop:
    # Calculate next Fibonacci number
    add.d       $f4, $f0, $f2       # f4 = f0 + f2 (next Fibonacci number)
    mov.d       $f0, $f2            # f0 = f2
    mov.d       $f2, $f4            # f2 = f4

    # Decrement counter
    sub         $t2, $t2, 1         # t2 = t2 - 1
    bgtz        $t2, fib_loop       # if t2 > 0, repeat loop

    # Result is in f2
    mov.d       $f0, $f2            # Move result to $f0
    jr          $ra

fib_base:
    # Base case
    mtc1        $a0, $f0            # Move integer n to floating-point register
    cvt.d.w     $f0, $f0            # Convert integer to double-precision
    jr          $ra

end_program:

    # RESTORE RETURN ADDRESS
    move        $ra, $s7
    jr          $ra
    add         $0, $0, $0
