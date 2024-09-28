.data
# Strings
query_T: .asciiz "Enter a value for T: "
query_N: .asciiz "Enter a value for N (0 - 20): "
query_t2: .asciiz "Enter a value for t2: "
result: .asciiz "Speedup = "
error: .asciiz "\nNumber must be in range! (0 - 20)\n"

# Numbers
T: .double 0.0
N: .double 0.0
t2: .double 0.0
speedup: .double 0.0

.text
.globl main
main:
    # SAVE ADDRESS
    # --------------------
    addu    $s7, $0, $ra    # Initial save address

    # QUERY
    # --------------------

    # Query T
    la      $a0, query_T    # Load 'query_T' into the function
    jal     input           # Call input() function
    s.d     $f0, T          # Save value to T

    # Query N
    jal     input_N         # Call input() function
    s.d     $f0, N          # Save value to N

    # Query t2
    la      $a0, query_t2   # Load 'query_t2' into the function
    jal     input           # Call input() function
    s.d     $f0, t2         # Save value to t2

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
    l.d     $f12, speedup       # Load 'speedup' double 
    syscall

    # END
    # --------------------
    j       exit_program

# Function: input(msg)
# Desc: Inputs a user for double type value
input:
    li      $v0, 4          # print_str (system call 4)
    syscall         

    li      $v0, 7          # read_double (system call 7)
    syscall

    jr      $ra             # Return to caller

input_N:
    li      $v0, 4          # syscall to print string
    la      $a0, query_N    # load address of prompt message
    syscall

    li      $v0, 7          # syscall to read double
    syscall                 # read double into $f0

    # Convert integers to double for comparison
    li      $t1, 0          # Load 0
    mtc1    $t1, $f2        # move 0 to $f1 (float)
    cvt.d.w $f2, $f2        # convert word to double

    li      $t2, 21         # Load 21
    mtc1    $t2, $f4        # move 21 to $f2 (float)
    cvt.d.w $f4, $f4        # convert word to double

    # Check if less than 0
    c.lt.d  $f0, $f2        # compare if input < 0
    bc1t    display_error   # if true, jump to error

    # Check if greater than 20
    c.lt.d  $f0, $f4        # compare if input < 20
    bc1f    display_error   # if false, jump to error

    jr      $ra              # return from function

display_error:
    li      $v0, 4           # syscall to print string
    la      $a0, error       # load address of error message
    syscall
    j       input_N        # jump back to input prompt

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
    l.d     $f4, 0 ($a1)    # Load 'N' to f2
    l.d     $f6, 0 ($a2)    # Load 't2' to f2

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