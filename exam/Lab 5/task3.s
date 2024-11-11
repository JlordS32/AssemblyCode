.data
P: .word 0, 0, 0, 0, 0, 0, 0, 0
Q: .word 0, 0, 0, 0, 0, 0, 0, 0
query: .asciiz "Enter N (1 - 9): "
input_1: .asciiz "Enter N["
input_2: .asciiz "]: "
Q_msg_1: .asciiz "Q["
Q_msg_2: .asciiz "]: "
P_msg_1: .asciiz "P["
P_msg_2: .asciiz "]: "
endl: .asciiz "\n"
N: .word 0

.text
.globl main
main:
    # SAVE ADDRESS
    # --------------------
    addu    $s7, $0, $ra

    # CALCULATE
    # --------------------
    li      $v0, 4              # print_str (syscall 4)
    la      $a0, query          # Load 'query'
    syscall                     

    li     $v0, 5              # read_int (syscall)
    syscall
    sw      $v0, N              # Store input into N

    # Loop setup
    la      $s0, P              # Load 'P' base address 
    la      $s1, Q              # Load 'Q' base address
    lw      $s2, N              # Load value of N 
    li      $t0, 0              # Index
 
    # LOOP
    # --------------------
loop:
    move    $t1, $t0            # Copy i over
    sll     $t1, $t1, 2         # Calculate offset
    add     $t2, $s0, $t1       # P base + offset
    add     $t3, $s1, $t1       # Q base + offset

    li      $v0, 4              # print_str (syscall 4)
    la      $a0, input_1        # Load 'input_1'
    syscall

    li      $v0, 1              # print_int (syscall 1)
    move    $a0, $t0            # print index
    syscall

    li      $v0, 4              # print_str (syscall 4)
    la      $a0, input_2        # Load 'input_2'
    syscall

    li      $v0, 5
    syscall
    sw      $v0, 0 ($t2)        # Store value into P[i]
    sw      $v0, 0 ($t3)        # Store value into Q[i]

    add     $t0, $t0, 1         # i++

    # Branching
    blt     $t0, $s2, loop      # Branch if less than N

    li      $v0, 4              # print_str (syscall 4)
    la      $a0, endl           # Load 'P_msg_2'
    syscall

    # PRINT P
    # --------------------
    li      $t0, 0              # Index
print_P:
    move    $t1, $t0            # Copy i over
    sll     $t1, $t1, 2         # Calculate offset
    add     $t2, $s0, $t1       # P base + offset

    li      $v0, 4              # print_str (syscall 4)
    la      $a0, P_msg_1        # Load 'P_msg_1'
    syscall

    li      $v0, 1              # print_int (syscall 1)
    move    $a0, $t0            # print index
    syscall

    li      $v0, 4              # print_str (syscall 4)
    la      $a0, P_msg_2        # Load 'P_msg_2'
    syscall

    li      $v0, 1              # print_int (sycall 1)
    lw      $a0, 0 ($t2)        # Load value
    syscall

    li      $v0, 4              # print_str (syscall 4)
    la      $a0, endl           # Load 'endl'
    syscall
    
    add     $t0, $t0, 1         # i++

    # Branching
    blt     $t0, $s2, print_P   # Branch if less than N

    li      $v0, 4              # print_str (syscall 4)
    la      $a0, endl           # Load 'P_msg_2'
    syscall

    # PRINT P
    # --------------------
    li      $t0, 0              # Index
print_Q:
    move    $t1, $t0            # Copy i over
    sll     $t1, $t1, 2         # Calculate offset
    add     $t2, $s1, $t1       # P base + offset

    li      $v0, 4              # print_str (syscall 4)
    la      $a0, Q_msg_1        # Load 'Q_msg_1'
    syscall

    li      $v0, 1              # print_int (syscall 1)
    move    $a0, $t0            # print index
    syscall

    li      $v0, 4              # print_str (syscall 4)
    la      $a0, Q_msg_2        # Load 'Q_msg_2'
    syscall

    li      $v0, 1              # print_int (sycall 1)
    lw      $a0, 0 ($t2)        # Load value
    syscall

    li      $v0, 4              # print_str (syscall 4)
    la      $a0, endl           # Load 'endl'
    syscall
    
    add     $t0, $t0, 1         # i++

    # Branching
    blt     $t0, $s2, print_Q   # Branch if less than N

exit:
    # RESTORE ADDRESS
    # --------------------
    addu    $ra, $0, $s7
    jr      $ra
    add     $0, $0, $0