.data
message: .asciiz "Hello, World! "    # A string stored in the initialized data section
number: .word 5                     # An integer variable initialized to 5

.text
.globl main
main:
    # STORE ADDRESS
    addu    $s7, $0, $ra

    # ACCESSING DATA
    li      $v0, 4          # Service call 4 to print strings
    la      $a0, message    # We load the address of 'message' label
    syscall

    lw      $t0, number     # We load the value of number into $t0

    li      $v0, 1          # Service call 1 to print integer
    move    $a0, $t0        # We pass the value of $t0 as argument
    syscall

    # RESTORE ADDRESS       
    addu    $ra, $0, $s7
    jr      $ra