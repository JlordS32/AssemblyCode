.data
.align 2
Z: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
X: .word 0
msg: .asciiz "Result: "
query: .asciiz "Enter a value (0 - 15): "

.text
.globl main
main:
    # SAVE ADDRESS
    # ------------------------------------
    addu    $s7, $0, $ra        # Save main address

    # QUERY
    # ------------------------------------
    li      $v0, 4              # print_str (syscall 4)
    la      $a0, query          # Load 'query' variable
    syscall

    li      $v0, 5              # read_int (syscall 5)
    syscall 
    addu    $t0, $0, $v0        # Copy input into k

    li      $v0, 4              # print_str (syscall 4)
    la      $a0, query          # Load 'query' variable
    syscall

    li      $v0, 5              # read_int (syscall 5)
    syscall 
    addu    $t1, $0, $v0        # Copy input into m

    # CALCULATING
    # ------------------------------------
    la      $s0, Z              # load Z base address

    # Get Z[k]
    sll     $t2, $t0, 2
    add     $t2, $t2, $s0       # Get offset for Z[k]
    lw      $s1, 0($t2)         # Load Z[k]

    # Get Z[k+m]
    add     $t3, $t1, $t0       # Perform k + m
    sll     $t3, $t3, 2         # Shift left 
    add     $t3, $t3, $s0       # Get offset of Z[k+m]
    lw      $s2, 0($t3)         # Load Z[k+m]

    # Perform Z[k] + Z[k+m]
    add     $s3, $s1, $s2       # Perform Z[k] + Z[k+m]

    sw      $s3, 48 ($s0)       # Load into Z[12]

    # PRINTING
    # ------------------------------------
    li      $v0, 4              # print_str (syscall 4)
    la      $a0, msg            # Load 'msg' variable
    syscall

    lw      $a0, 48 ($s0)
    li      $v0, 1
    syscall

    # RESTORE ADDRESS
    # ------------------------------------
    addu    $ra, $0, $s7        # Restore main address
    jr      $ra                 # Return to caller
    add     $0, $0, $0          # nop


