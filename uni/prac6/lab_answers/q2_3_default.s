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
    # Base case: if n < 2, return n
    slt     $t0, $a0, 2             # Set $t0 to 1 if $a0 < 2
    bne     $t0, $zero, fib_base    # If n < 2, jump to base case

    # Save a space in the stack
    addi    $sp, $sp, -12
    sw      $ra, 8($sp)
    sw      $a0, 4($sp)

    # Calculate for Fib (n - 1)
    addi    $a0, $a0, -1
    jal     fib
    sw      $v0, 0($sp)

    # Calculate for Fib (n - 2)
    lw      $a0, 4($sp)
    addi    $a0, $a0, -2
    jal     fib

    # Calculate results
    lw      $t0, 0($sp)         # Fib (n - 1)
    move    $t1, $v0            # Fib (n - 2)
    add     $v0, $t1, $t0       # Fib (n - 1) + Fib (n - 2)

    lw      $ra, 8($sp)
    addi    $sp, $sp, 12
    jr      $ra

fib_base:
    # Base case: return n
    move    $v0, $a0                  # Return n in $v0
    jr      $ra                       

end_program:

    # RESTORE ADDRESS
    move    $ra, $s7
    jr      $ra
    add    $0, $0, $0