main:
        li      $t0, 2
        li      $t1, 1

        .data
Hello:  .asciiz "Hello "
world:  .asciiz "world!\n"
        .text

        bne		$t0, $t1, print_world

        li      $v0, 4
        la      $a0, Hello
        syscall

print_world:
        li      $v0, 4
        la      $a0, world
        syscall

        beq     $t0, $t1, end_if

        li      $v0, 4
        la      $a0, Hello
        syscall

end_if:
        li      $v0, 4
        la      $a0, world
        syscall

        .data
if:     .asciiz "If\n"
else:   .asciiz "Else\n"
        .text

        bge     $t0, $t1, else1

        la      $a0, if
        syscall

        j       end_else
else1:
        la      $a0, else
        syscall

end_else:

        .data
ge:     .asciiz "Greater or equal\n"
nge:    .asciiz "Not greater or equal\n"
        .text

        blt     $t0, $t1, else5

        la      $a0, ge
        syscall
        j       end_else4

else5:
        la      $a0, nge
        syscall

end_else4:



