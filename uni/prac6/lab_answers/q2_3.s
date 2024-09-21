    .data
query: .asciiz "Enter Fib(n): "
result_1: .asciiz "\nElement ["
result_2: .asciiz "] of Fibonacci string is: "
error: .asciiz "Number must be between 2 - 45!\n"
lower_range: .word 2
upper_range: .word 45

    .text
    .globl main
main:
    # SAVE ADDRESS
    # ----------------
    move    $s7, $ra

    jal     input

    # Copy value over to $s1
    move    $s1, $v0            # n = $v0

    # Call fib function
    move    $a0, $s1          # Load n to $a0 for fib function
    li      $a1, 1
    li      $a2, 0
    jal     fib               # Call fib()
    move    $s0, $v0          # result = fib(n)

    # OUTPUT RESULTS
    # ----------------
    # Print value
    li      $v0, 4              # print_str (system call 4)
    la      $a0, result_1
    syscall

    li      $v0, 1              # print_int (system call 1)
    move    $a0, $s1
    syscall

    li      $v0, 4              # print_str (system call 4)
    la      $a0, result_2
    syscall

    li      $v0, 1              # print_int (system call 1)
    move    $a0, $s0
    syscall
    
    # END 
    # ----------------
    j       end_program

# INPUT FUNCTION
input:
    # INPUT USER
    # ----------------
    li      $v0, 4              # print_str (system call 4)
    la      $a0, query
    syscall

    # Read integer
    li      $v0, 5              # read_int (system call 5)
    syscall
    
    # CHECK CONDITION
    # ----------------
    # Condition: Number between 2 - 45
    lw      $t1, lower_range
    lw      $t2, upper_range
    slt     $t0, $v0, $t1
    bne     $t0, $0, input_error        # Loop back
    sgt     $t0, $v0, $t2
    bne     $t0, $0, input_error        # Loop back

    # Return to caller
    jr      $ra

input_error:
    
    li      $v0, 4
    la      $a0, error
    syscall

    j       input

# FIBONACCI FUNCTION
#   int fib(int term, int val = 1, int prev = 0)
#   {
#       if(term == 0) return prev;
#       return fib(term - 1, val+prev, val);
#   }
    .globl fib
# a0 = term
# a1 = val
# a2 = prev
fib:
    # Base case: if term == 0 ($a0 == 0), return prev
    beq     $a0, $zero, fib_base

    # Save return address and registers onto the stack
    addi    $sp, $sp, -12          # Allocate space for 3
    sw      $ra, 8($sp)            # Save return address
    sw      $a0, 4($sp)            # Save term
    sw      $a1, 0($sp)            # Save val

    # Compute fib(term - 1, val + prev, val)
    add     $t0, $a1, $a2          # $t0 = val + prev
    move    $t1, $a1               # $t1 = val
    addi    $a0, $a0, -1           # term - 1
    move    $a1, $t0               # val = val + prev
    move    $a2, $t1               # prev = val

    # Recursive call
    jal     fib

    # Restore registers after recursive call
    lw      $ra, 8($sp)            # Restore return address
    lw      $a0, 4($sp)            # Restore term
    lw      $a1, 0($sp)            # Restore val
    addi    $sp, $sp, 12           # Free stack space

    jr      $ra                    # Return to caller

fib_base:
    move    $v0, $a2               # Return prev as the result
    jr      $ra                    # Return to caller              

end_program:

    # RESTORE ADDRESS
    move    $ra, $s7
    jr      $ra
    add    $0, $0, $0