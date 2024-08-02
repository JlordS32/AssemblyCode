.data
ask_operation: .asciiz "\nWhat operation do you want to use?\n0. Addition\n1. Subtraction\n2. Multiplication\n3. Division\n"
q:  .asciiz "Please make your choice (0-3): "
error_string: .asciiz "Error 101: OPTION OUT OF BOUNDS!"
endl: .asciiz "\n"
ask_number: .asciiz "Please input integer 1: "
ask_number2: .asciiz "Please input integer 2: "
answer_string: .asciiz "Answer: "
buffer: .space 2
confirmation_string: .asciiz "\n\nTry again? [Y/N]: "
zero_error_string: .asciiz "Error 105: Cannot divide by zero!"

.text
main:
    li      $v0, 4
    la      $a0, ask_operation
    syscall

    li      $v0, 4
    la      $a0, q
    syscall

    li      $v0, 5
    syscall
    move    $t0, $v0

    # Switch case
    beq     $t0, $zero, addition
    li      $t1, 1
    beq     $t0, $t1, subtraction
    li      $t1, 2
    beq     $t0, $t1, multiplication
    li      $t1, 3
    beq     $t0, $t1, division
    
    # Default case
    j       default

addition:
    jal    user_input
    add    $s2, $s0, $s1
    j      display_results

subtraction:
    jal    user_input
    sub    $s2, $s0, $s1
    j      display_results

multiplication:
    jal    user_input
    mul    $s2, $s0, $s1
    j      display_results

division:
    jal    user_input

    # Catch error
    beq    $s1, $zero, cannot_divide_by_zero

    div    $s0, $s1
    mflo   $s2  # Move the quotient into $s2
    j      display_results

cannot_divide_by_zero:

    # Print error
    li      $v0, 4
    la      $a0, zero_error_string
    syscall

    j       tryAgain

user_input:
    # Query 1: Please input integer 1:
    li      $v0, 4
    la      $a0, ask_number
    syscall
    
    li      $v0, 5
    syscall
    move    $s0, $v0

    # Query 2: Please input integer 2:
    li      $v0, 4
    la      $a0, ask_number2
    syscall
    
    li      $v0, 5
    syscall
    move    $s1, $v0

    jr     $ra 

display_results:
    # Display results
    li      $v0, 4
    la      $a0, answer_string
    syscall

    li      $v0, 1
    move    $a0, $s2
    syscall

    j       tryAgain

default:
    li      $v0, 4
    la      $a0, error_string
    syscall
    j       tryAgain

tryAgain:
    # Confirmation input
    li      $v0, 4
    la      $a0, confirmation_string
    syscall

    # Store input
    li      $v0, 8
    la      $a0, buffer
    li      $a1, 2
    syscall
    
    lb      $t0, 0($a0)    
    li      $t1, 'N'        # Load ASCII Value of N
    beq     $t0, $t1, exitProgram
    li      $t1, 'Y'        # Load ASCII Value of Y
    beq     $t0, $t1, main

    # Default error message
    li      $v0, 4
    la      $a0, error_string
    syscall
    j       tryAgain

exitProgram:
    li      $v0, 10
    syscall
