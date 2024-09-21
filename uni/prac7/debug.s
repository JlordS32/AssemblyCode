.data
query: .asciiz "Enter an integer: "

.text
.globl main
main:
    move    $s7, $ra

    # Query user
    li      $v0, 4
    la      $a0, query
    syscall

    # Read int
    li      $v0, 5
    syscall

    move    $s0, $v0
    sra     $t0, $s0, 2

    li      $t1, 0xffff
    and     $t3, $t0, $t1

    j       exit

exit:   
    # Restore address and return
    move    $ra, $s7
    jr      $ra
    add     $0, $0, $0