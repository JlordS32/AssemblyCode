
        .data
zero_string:       .asciiz "Zero"
one_string:        .asciiz "One"
two_string:        .asciiz "Two"
default_string:    .asciiz "Default"
        .text


main:
        li      $t0, 20
        li      $t1, 0

        beq     $t0, $zero, zero
        li      $t9, 1
        beq     $t0, $t9, one
        li      $t9, 2
        beq     $t0, $t9, two
        j       default

zero:   
        li      $v0, 4
        la      $a0, zero_string
        syscall
        j       end_case

one:   
        li      $v0, 4
        la      $a0, one_string
        syscall
        j       end_case

two:   
        li      $v0, 4
        la      $a0, two_string
        syscall
        j       end_case

default:   
        li      $v0, 4
        la      $a0, default_string
        syscall
        j       end_case

end_case:
