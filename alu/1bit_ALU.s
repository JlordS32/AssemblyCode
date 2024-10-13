.data
error_msg: .asciiz "Invalid operation!"

.text
.globl main
main:

    li      $t0, 1      # A = 1
    li      $t1, 1      # B = 1
    li      $t2, 2      # Opcode = Number

    # Ensure inputs are 1-bit values
    andi    $t0, $t0, 1
    andi    $t1, $t1, 1
    andi    $t2, $t2, 3

    # Perform operations based on opcode
    # Operation = 0, AND
    addi    $t4, $0, 0
    beq     $t2, $t4, op_and
    # Operation = 1, OR
    addi    $t4, $0, 1
    beq     $t2, $t4, op_or
    # Operation = 2, ADD
    addi    $t4, $0, 2
    beq     $t2, $t4, op_add
    # Operation = 3, SUB
    addi    $t4, $0, 3
    beq     $t2, $t4, op_sub

    j       error

op_and:
    and     $t3, $t0, $t1
    j       end

op_or:
    or      $t3, $t0, $t1
    j       end

op_add:
    addu    $t3, $t0, $t1
    andi    $t3, $t3, 1 
    j       end

op_sub:
    sub     $t3, $t0, $t1
    andi    $t3, $t3, 1 
    j       end

end:
    li      $v0, 1
    move    $a0, $t3
    syscall

    j       exit

error:`

    li      $v0, 4
    la      $a0, error_msg
    syscall

exit:

    li      $v0, 10
    syscall

