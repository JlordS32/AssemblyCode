
  # Print out f
.data
.globl  message
message:  .asciiz "\nThe value of f is: " # string to print

.text
.globl main
main:                          # main has to be a global label
    move    $s7, $ra           # save the return address in $s7

    # Initiliase local variables
    addi    $s0, $0, -1        # initialize $s0 to -1
    addi    $a0, $0, 3         # g = 3
    addi    $a1, $0, -18       # h = -18
    addi    $a2, $0, 12        # i = 12
    addi    $a3, $0, 13        # j = 13

    # Jump to function
    jal     leaf_example       # call the function leaf_example  

    # Set the value to $s0
    add     $s0, $0, $v0       # set f to the computed value

    # Print string
    li      $v0, 4             # print_str (system call 4)
    la      $a0, message       # load address of string
    syscall

    # Print integer
    li      $v0, 1             # print_int (system call 1)
    move    $a0, $s0
    syscall

    # Restore return address and return
    move    $ra, $s7           # restore the return address
    jr      $ra                # return to the calling program
    add     $0, $0, $0

leaf_example:

    add     $sp, $sp, -12       # make space on the stack for three items

    # Save into the stack
    sw      $s2, 8($sp)        # save register $s2       
    sw      $s1, 4($sp)        # save register $s1
    sw      $s0, 0($sp)        # save register $s0

    # g + h
    add     $s1, $a0, $a1      # register $s1 contains g + h
    # i + j
    add     $s2, $a2, $a3      # register $s2 contains i + j

    sub     $s0, $s1, $s2      # f = (g + h) - (i + j)

    # Return f
    add     $v0, $s0, $0

    # Restore from the stack
    lw      $s0, 0($sp)        # restore register $s0
    lw      $s1, 4($sp)        # restore register $s1
    lw      $s2, 8($sp)        # restore register $s2

    add     $sp, $sp, 12       # adjust the stack pointer

    # Return to caller
    jr      $ra                # return to the calling program
