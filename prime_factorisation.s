.data
q:      .asciiz "Enter a number to factor: "
r:      .asciiz "The prime factorisation of "
r2:     .asciiz " is "
comma:  .asciiz ", "
nl:     .asciiz "\n"

.text
main:

    # Print q
    li      $v0, 4      # Operation call 4 = store address
    la      $a0, q      # Pass q as the argument to the function call
    syscall

    # Wait an input for user (integer)
    li      $v0, 5      # Operation call 5 = read integer
    syscall
    move    $t0, $v0

    # Print r
    li      $v0, 4
    la      $a0, r
    syscall

    # Print the value received from user
    li      $v0, 1      # Operation call 1 = store integer
    move    $a0, $t0    # Store input at $t0 register
    syscall

    # Print string " is "
    li      $v0, 4
    la      $a0, r2     # r2 = " is " check above
    syscall

    # COUNTER VARIABLE
    li      $t1, 2

# Loop starts
while:

    # Keep looping while counter variables
    # is not greater than our input at $t0
    # if condition is true, we jump to endWhile
    bge     $t1, $t0, endWhile

    # Use div (division) instructions at get
    # remainder at the mfhi
    # mfhi = stores remainder
    div     $t0, $t1
    mfhi    $t2         # Store remainder at $t2
    bnez    $t2, else   # Check if remainder is 0, otherwise jump to else

    # Prints "current value of COUNTER VARIABLE, "
    li      $v0, 1
    move    $a0, $t1
    syscall
    li      $v0, 4
    la      $a0, comma
    syscall

    # Increment COUNTER VARIABLE by 1
    addi    $t1, $t1, 1
    
    # Jump back to initial parent function to loop.
    j       while

# This section only executes if the remainder of COUNTER VARIABLE and our
# input is not 0, that is the number is not prime.
else:
    # Increment COUNTER VARIABLE
    addi    $t1, $t1, 1

    # Loop back to while
    j       while

endWhile:
    # Last number isn't printed, so we have to manually print it here'
    # NOTE: Last number is the number itself
    li      $v0, 1
    move    $a0, $t0 
    syscall

    # Not really needed but okay
    li      $v0, 4
    la      $a0, nl
    syscall
    
    # Terminate program
    li      $v0, 10
    syscall