.data
q:  .asciiz "Enter an integer: "
r:  .asciiz "! = "
nl: .asciiz "\n"

.text
main:
    # Print query for integer
    li      $v0, 4
    la      $a0, q
    syscall

    # Wait for user input and store to $t0 register
    li      $v0, 5      
    syscall
    move    $t0, $v0    # Put user input from $v0 to $t0

    # Variable initialisation
    li      $t2, 1      # Counter
    li      $t1, 1      # Result

loop:

    bgt     $t2, $t0, endLoop

    # Calculate factorial
    mul     $t1, $t1, $t2

    # Increment counter i = $t2
    addi    $t2, $t2, 1
    j       loop

endLoop:
    # Display results from $t0 
    li      $v0, 1      
    move    $a0, $t0    # Print $t0, la $a0, .asciiz for strings
    syscall

    # Print "! ="
    li      $v0, 4
    la      $a0, r
    syscall

    # Print output
    li      $v0, 1
    move    $a0, $t1
    syscall

    # Print new line
    li      $v0, 4
    la      $a0, nl
    syscall

    # Terminate program
    li      $v0, 10
    syscall


