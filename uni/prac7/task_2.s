# TASK II

.data
prompt: .asciiz "Enter value for p (0 to terminate): "
unsigned: .asciiz "Unsigned value: "
signed: .asciiz "Signed value: "
endl: .asciiz "\n"
terminate: .asciiz "Program terminated. "
p: .word 0

.text
.globl main
main:
    # SAVE ADDRESS
    # -----------------
    addu    $s7, $ra, $0     # Save address first to

loop:
    # PROMPT
    # -----------------
    li      $v0, 4          # print_str (system call 4)
    la      $a0, prompt     # load prompt data
    syscall

    li      $v0, 5          # read_int (system call 5)
    syscall
    sw      $v0, p          # Store value to 'p'

    # CONDITION CHECK
    # -----------------
    lw      $t0, p          # Load 'p' to $to
    beqz    $t0, exit       # Branch to exit if zero.

    # FUNCTION CALL
    # -----------------
    lw      $a0, p          # Pass p
    jal     extract         # Call extract()
    move    $s0, $v0

    # OUTPUT
    # -----------------
    # Display unsigned
    jal     print_newline   # print newline

    li      $v0, 4          # print_str (system call 4)        
    la      $a0, unsigned   # Load 'unsigned' data
    syscall

    li      $v0, 1          # print_int (system call 1)
    move    $a0, $s0        # Copy the result from extract() to print
    syscall

    # Display signed
    sll     $s0, $s0, 27    # Ensure sign extension
    sra     $s0, $s0, 27    # Return to position

    jal     print_newline   # print newline

    li      $v0, 4          # print_str (system call 4)        
    la      $a0, signed     # Load 'unsigned' data
    syscall

    li      $v0, 1          # print_int (system call 1)
    move    $a0, $s0        # Copy the result from extract() to print
    syscall

    # END
    # ----------------
    jal     print_newline   # print newline
    jal     print_newline   # print newline

    j       loop            # Continue

# Function: print_newline()
# Desc: Prints a new line
print_newline:
    li      $v0, 4          # print_str (system call 4)        
    la      $a0, endl       # Load 'endl' data
    syscall

    jr      $ra             # Return to caller

# Function: extract()
# Desc: Extracts the most significant 5 bits starting at position bit 3.
# Return: Extracted field
extract:
    # Save Stack
    sub     $sp, $sp, 8     # Make a space for two items
    sw      $s0, 4 ($sp)    # Save register $s0
    sw      $s1, 0 ($sp)    # Save register $s1

    # Copy
    move    $s0, $a0        # Copy the value over to $s0

    # Mask
    li      $s1, 0x1f       # Mask to extract 5-bit
    sll     $s1, $s1, 3     # Move mask bits by 3 bit places to the left
    and     $s1, $s1, $s0   # Apply mask

    # Adjustments
    sra     $s1, $s1, 3     # Move least significant bit at 3, for readjusment and retain sign
    move    $v0, $s1        # Finally, we can return 

    # Restore stack
    lw      $s0, 0 ($sp)    # Restore $s0
    lw      $s1, 4 ($sp)    # Restore $s1
    add     $sp, $sp, 8     # Free up stack

    jr      $ra             # Return to caller

exit:
    jal     print_newline   # print newline

    li      $v0, 4          # print_str (system call 4)        
    la      $a0, terminate  # Load 'terminate' data
    syscall

    # RESTORE ADDRESS
    # -----------------
    addu    $ra, $s7, $0
    jr      $ra
    add     $0, $0, $0