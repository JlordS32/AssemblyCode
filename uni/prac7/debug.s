.data
query: .asciiz "Enter an integer: "

.text
.globl main
main:
    move    $s7, $ra

    li      $t0, 0x80000000
    addu    $t0, $t0, -1

    j       exit

exit:   
    # Restore address and return
    move    $ra, $s7
    jr      $ra
    add     $0, $0, $0