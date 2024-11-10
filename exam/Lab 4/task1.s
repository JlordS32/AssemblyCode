.data
.align 2
Z: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
X: .word 0
msg: .asciiz "Result: "

.text
.globl main
main:
    # SAVE ADDRESS
    # ------------------------------------
    addu    $s7, $0, $ra        # Save main address

    # CALCULATING
    # ------------------------------------
    la      $s0, Z              # Load 'Z' base address

    lw      $t0, 12 ($s0)       # Load Z[3]
    lw      $t1, 20 ($s0)       # Load Z[5]

    add     $t2, $t0, $t1       # Z[3] + Z[5]
    sw      $t2, X              # Store value to X

    # PRINTING
    # ------------------------------------
    li      $v0, 4              # print_str (syscall 4)
    la      $a0, msg            # Load msg
    syscall

    li      $v0, 1
    addu    $a0, $0, $t2        
    syscall

    # RESTORE ADDRESS
    # ------------------------------------
    addu    $ra, $0, $s7        # Restore main address
    jr      $ra                 # Return to caller
    add     $0, $0, $0          # nop


