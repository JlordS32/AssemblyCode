.data
error: "Invalid operation!"

.text
.globl main
main:

    li      $t0, 0      # A = 0
    li      $t1, 1      # B = 1
    li      $t2, 3      # Opcode = 3

    # Ensure inputs are 1-bit values
    andi    $t0, $t0, 1
    andi    $t0, $t0, 1
    andi    $t0, $t0, 3

    # Perform operations based on opcode
    # Operation = 0, AND
    addi    $t4, $0, 0
    beq     $t2, $t4, op_and
    # Operation = 1, AND
    addi    $t4, $0, 1
    beq     $t2, $t4, op_or
    # Operation = 2, AND
    addi    $t4, $0, 2
    beq     $t2, $t4, op_add
    # Operation = 3, AND
    addi    $t4, $0, 3
    beq     $t2, $t4, op_sub

op_and:
    andi    $t3, $t0, $t1
    j       end

op_or:
    ori     $t3, $t0, $t1
    j       end

op_add:
    add     $t3, $t0, $t1
    j       end

op_sub:
    sub     $t3, $t0, $t1
    j       end

end:
    li      $v0, 1
    move    $a0, $t3
    syscall

    j       exit

exit:

    li      $v0, 10
    syscall

