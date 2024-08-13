.data
hello: .asciiz "Hello world\n"
number: .word 42

.text
main:
    # Save address
    move    $s7, $ra

    # Print .data label "hello"
    li      $v0, 4          # Service call 4 for print string
    la      $a0, hello      # Load the address into $a0
    syscall

    lw      $t0, number     # Load the value of label "number" to $t0
    addi    $t0, $t0, 8     # Add 8 to the number

    move    $a0, $t0        # Move number to $a0 to print
    li      $v0, 1          # Service call 1 for print integer
    syscall

    # Restore address
    move    $ra, $s7
    jr      $ra
    add    $0, $0, $0

