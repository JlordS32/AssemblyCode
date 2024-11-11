.data
query_msg: .asciiz "Enter n (2 - 45): "
error_msg: .asciiz "Error: Number not in range!\n"
fib_msg_1: .asciiz "Fib["
fib_msg_2: .asciiz "]: "
n: .word 0

.text
.globl main
main:
    # RESTORE ADDRESS
    # ----------------------
    addu    $s7, $0, $ra        # Restore address

    jal     query               # Call query()
    move    $s0, $v0            # Store
    sw      $s0, n              # Store value to n

    # CALLING FIB() 
    # ----------------------
    lw      $s0, n              # Load n
    move    $a0, $s0            # term = n ($a0)
    li      $a1, 1              # val = $a1           
    li      $a2, 0              # prev = $a2
    jal     fib                 # Call fib
    move    $s1, $v0

    # PRINT
    # ----------------------

    li      $v0, 4
    la      $a0, fib_msg_1
    syscall

    li      $v0, 1
    move    $a0, $s0
    syscall

    li      $v0, 4
    la      $a0, fib_msg_2
    syscall

    li      $v0, 1
    move    $a0, $s1
    syscall

    j       exit_program

# FIBONACCI FUNCTION
#   int fib(int term, int val = 1, int prev = 0)
#   {
#       if(term == 0) return prev;
#       return fib(term - 1, val + prev, val);
#   }
.globl fib
# a0 = term
# a1 = val
# a2 = prev
fib:
    # Base case: if term == 0 ($a0 == 0), return prev
    beq     $a0, $0, fib_base

    sub     $sp, $sp, 12        # Make space for five items
    sw      $ra, 8($sp)         # Save return address
    sw      $a0, 4($sp)         # Save term
    sw      $a1, 0($sp)         # Save val

    # Compute fib(term - 1, val + prev, val)
    add     $t0, $a1, $a2       # $t0 = val + prev
    move    $t1, $a1            # $t1 = val
    
    # Passing arguments
    addi    $a0, $a0, -1        # term = term - 1
    move    $a1, $t0            # val = $t2 (val + prev)
    move    $a2, $t1            # prev = $t1 (val)

    jal     fib

    # Restore registers after recursive call
    lw      $a1, 0($sp)         # Restore val
    lw      $a0, 4($sp)         # Restore term
    lw      $ra, 8($sp)         # Restore return address
    addi    $sp, $sp, 12        # Free stack space

    jr      $ra                 # Return to caller

fib_base:
    move    $v0, $a2            # Return prev as the result
    jr      $ra                 # Return to caller       

query:
    sub     $sp, $sp, 12        # Make space for two items
    sw      $ra, 8 ($sp)        # Save $ra 
    sw      $s0, 4 ($sp)        # Save $s0 
    sw      $s1, 0 ($sp)        # Save $s1 

query_loop:
    li      $v0, 4              # print_str (syscall 4)
    la      $a0, query_msg      # Load 'query_msg' to print
    syscall

    li      $v0, 5              # read_int
    syscall

    li      $s0, 2
    blt     $v0, $s0, error     # Branch if less than 2
    li      $s1, 45
    bgt     $v0, $s1, error     # Branch if greater than 45

    lw      $s1, 0 ($sp)        # Restore $s1 
    lw      $s0, 4 ($sp)        # Restore $s0 
    lw      $ra, 8 ($sp)        # Restore $ra 
    add     $sp, $sp, 12        # Free stack

    jr      $ra 

error:
    li      $v0, 4              # print_str (syscall 4)
    la      $a0, error_msg      # Load 'error_msg' to print
    syscall

    j       query_loop          # Jump back to query

exit_program:
    # RESTORE ADDRESS
    # ----------------------
    addu    $ra, $0, $s7        # Restore address
    jr      $ra                 # Return to caller
    nop
