        .data
prompt: .asciiz "Please enter an integer: "
respon: .asciiz "You have entered "
endl:   .asciiz "\n"
        .text

main: 
        li      $v0, 4
        la      $a0, prompt
        syscall

        li      $v0, 5
        syscall
        move    $t0, $v0

        li      $v0, 4
        la      $a0, respon
        syscall

        li      $v0, 1
        move    $a0, $t0
        syscall

        li      $v0, 4
        la      $a0, endl
        syscall

        li      $v0, 10
        syscall