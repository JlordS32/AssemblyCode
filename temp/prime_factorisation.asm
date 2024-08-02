.data
q:      .asciiz "Please enter an integer: "
r:      .asciiz "The prime factors for "
r2:     .asciiz " are: "
comma:  .asciiz ", "
endl:   .asciiz "\n"

.text
main:

    # Print q
    li      $v0, 4
    la      $a0, q
    syscall

    # Wait for an input from user
    li      $v0, 5
    syscall
    move    $t0, $v0

    # Print r
    li      $v0, 4
    la      $a0, r
    syscall

    # Print number that has been inputted
    li      $v0, 1
    move    $a0, $t0
    syscall

    # Print r2
    li      $v0, 4
    la      $a0, r2
    syscall

    # Initialise counter variable
    li      $t1, 2

loop:

    bge     $t1, $t0, endLoop

    # $t0 / $t1
    div     $t0, $t1

    # Store remainder at $t2
    mfhi    $t2

    # If not equal to zero go to else
    bnez    $t2, else

    li      $v0, 1
    move    $a0, $t1
    syscall

    li      $v0, 4
    la      $a0, comma
    syscall

    addi    $t1, $t1, 1

    j       loop

else:
    addi    $t1, $t1, 1

    j       loop

endLoop:

    li      $v0, 1
    move    $a0, $t0
    syscall

    li      $v0, 10
    syscall    


