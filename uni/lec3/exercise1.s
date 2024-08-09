.data
        .align  2
        .globl  save
save:   .word   0, 0, 0, 0, 0, 0, 0, 6, 3, 2

        .globl  main
.text
main:
    addu    $s7,    $0,     $ra

    #  Variables
    li      $s3,    0                           # i = 0
    li      $s4,    1                           # j = 1
    li      $s5,    0                           # k = 0
    la      $s6,    save                        # save[]

loop:
    add     $t1,    $s3,    $s3
    add     $t1,    $t1,    $t1
    add     $t1,    $t1,    $s6                 # Correctly calculate the address

    lw      $t0,    0($t1)                      # Access save[i]

    bne     $t0,    $s5,    exit_code
    add     $s3,    $s3,    $s4                 # i = i + j

    j       loop


exit_code:
    addu    $ra,    $0,     $s7
    jr      $ra