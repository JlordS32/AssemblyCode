.data
    # Define the double precision floating-point value
    double_val:
        .double 45678912345.567

    # Define a newline string for printing
    newline:
        .asciiz "\n"

.text
    .globl main

main:
    # Load the double precision value from memory
    ldc1 $f0, double_val     
    
    # Move double precision value to $f12 and $f13 for printing
    mov.d $f12, $f0          # Move the double precision value from 

    # Print the double precision value
    li $v0, 3                # System call code for print double
    syscall                  # Print the double value

    # Print a newline
    li $v0, 4                # System call code for print string
    la $a0, newline          # Load address of newline string
    syscall                  # Print the newline

    # Exit the program
    li $v0, 10               # System call code for exit
    syscall                  # Exit the program
