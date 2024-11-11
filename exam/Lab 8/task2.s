.data
# Strings
result: .asciiz "\nSpeedup (Fp proportion: "
end_bracket: .asciiz ") = "

# Numbers
T: .double 1.0
N: .double 5.0
t2: .double 0.0
increment: .double 0.1
speedup: .double 0.0

.text
.globl main
main:
    # SAVE ADDRESS
    # --------------------
    addu    $s7, $0, $ra    # Initial save address

    # Initialise index
    li      $t0, 11

loop:
    # FUNCTION CALL
    # --------------------
    la      $a0, T              # Load 'T'
    la      $a1, N              # Load 'N'
    la      $a2, t2             # Load 't2'
    la      $a3, speedup        # Pass speedup as reference
    jal     calculate_speedup

    # OUTPUT MESSAGE
    # --------------------
    li      $v0, 4              # print_str (system call 4)
    la      $a0, result         # Load 'result' string
    syscall

    li      $v0, 3              # print_double (system call 3)
    l.d     $f12, t2            # load current value of 't2'
    syscall

    li      $v0, 4              # print_str (system call 4)
    la      $a0, end_bracket    # load 'end_bracket' str
    syscall

    li      $v0, 3              # print_double (system call 3)  
    l.d     $f12, speedup       # Load 'speedup' double 
    syscall

    # Update index and t2
    sub     $t0, $t0, 1          # Decrement index by 1
    l.d     $f2, t2              # Load double from t2 into $f2
    l.d     $f4, increment       # Load constant 0.1 into $f4
    add.d   $f2, $f2, $f4        # Add $f2 and $f4, store result in $f2
    s.d     $f2, t2              # Store result into T

    # Brach if index is not equal to zero
    bnez    $t0, loop           # Loop if not zero

    # END
    # --------------------
    j       exit_program


calculate_speedup:
    # SAVE STACK
    # --------------------
    sub     $sp, $sp, 16    # Make space for 4 items
    sw      $ra, 12 ($sp)   # Save return address
    sw      $a0, 8 ($sp)    # Save $a0
    sw      $a1, 4 ($sp)    # Save $a1
    sw      $a2, 0 ($sp)    # Save $a2

    # LOAD ARGUMENTS
    # --------------------
    l.d     $f2, 0 ($a0)    # Load 'T' to f2
    l.d     $f4, 0 ($a1)    # Load 'N' to f4
    l.d     $f6, 0 ($a2)    # Load 'p' to f6

    # CALCULATE SPEEDUP
    # --------------------
    # Calculate t1 
    sub.d   $f8, $f2, $f6   # t1 = T - t2

    # Calculate t2'
    div.d   $f6, $f6, $f4   # t2' = t2 / N

    # Finally, we can calculate speedup
    # Speedup = T / t1 + t2' 
    add.d   $f6, $f6, $f8   # t1 + t2'
    div.d   $f0, $f2, $f6   # T2 / t1 + t2'

    # Update reference
    s.d     $f0, 0 ($a3)     

    # RESTORE STACK
    # --------------------
    lw      $a2, 0 ($sp)    # Restore $a2
    lw      $a1, 4 ($sp)    # Restore $a1
    lw      $a0, 8 ($sp)    # Restore $a0
    lw      $ra, 12 ($sp)    # Restore return address
    add     $sp, $sp, 16    # Free up the stack

    # RETURN
    jr      $ra             # Return to caller

# EXIT
# --------------------
exit_program:
    # RESTORE ADDRESS
    # --------------------
    addu    $ra, $0, $s7    # Restore initial address

    # EXIT
    # --------------------
    jr   $ra                # return to the main program
    add  $0, $0, $0         # nop