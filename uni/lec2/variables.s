    .data
    .globl mess
mess:   .asciiz "\nThe value of f is: "
f_word:      .word 0
g_word:      .word 5
h_word:      .word -20
i_word:      .word 13
j_word:      .word 3

    .text
    .globl main
main:
    addu    $s7, $0, $ra

    lw      $s1, g_word
    lw      $s2, i_word

    add     $s3, $s1, $s2

    li      $v0, 4
    la      $a0, mess
    syscall

    li      $v0, 1
    move    $a0, $s3
    syscall

    addu    $ra, $0, $s7
    jr      $ra
