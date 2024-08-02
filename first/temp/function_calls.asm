.data
q: .asciiz "Please enter integer 1: "
q2: .asciiz "Please enter integer 2: "


.text
main:

    # Input 1
    li      $v0, 4
    la      $a0, q
    syscall

    li      $v0, 5
    syscall
    move    $a0, $v0

    # Input 2
    li      $v0, 4
    la      $a0, q2
    syscall

    li      $v0, 5
    syscall
    move    $a1, $v0

    # Call function
    jal     add_numbers

    # Print result
    li      $v0, 1
    move    $a0, $v1
    syscall

    # Exit program
    li      $v0, 10
    syscall

add_numbers:
    add     $v1, $a0, $a1
    jr      $ra