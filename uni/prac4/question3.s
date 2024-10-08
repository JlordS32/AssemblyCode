#---------DATA SECTION-----------#
.data
.align 2    # Align the values by the multiple of 4
Z: .word 2, 4, 6, 8, 10, 12, 14, 16, 18, 20     # Setting up the array for Z
X: .word 0  # Defining X, so it's stored in the memory
result: .asciiz "The value of X is: "

#----------MAIN PROGRAM---------#
.text
.globl  main
main:
    # STORE ADDRESS
    addu    $s7, $0, $ra    # Store address to $s7

    la      $s0, Z          # Load address of the array "z"

    lw      $t0, 8($s0)     # Z[3] = 6
    lw      $t1, 16($s0)    # Z[5] = 10

    sub     $s1, $t0, $t1   # X = Z[3] - Z[5]
    
    sw      $s1, X          # Store word value into the word "x"

    # PRINT SECTION
    li      $v0, 4          # Service call 4 = print string
    la      $a0, result     # Load the address of "result"
    syscall                 

    li      $v0, 1          # Service call 1 = print integer
    move    $a0, $s1        # Move the value of X to $a0 to print
    syscall

    # RESTORE ADDRESS
    addu    $ra, $0, $s7    # Restore address
    jr      $ra             # Return to main program