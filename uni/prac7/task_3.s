# TASK III

.data
# String variables
prompt_p: .asciiz "Enter value for p (0 to terminate): "
prompt_n: .asciiz "Enter value for n: "
prompt_m: .asciiz "Enter value for m: "
unsigned: .asciiz "Unsigned value: "
signed: .asciiz "Signed value: "
endl: .asciiz "\n"
terminate: .asciiz "Program terminated. "
error: .asciiz "Error: n + m must not exceed 32."

# Integer variables
p: .word 0
n: .word 0
m: .word 0
max: .word 32

.text
.globl main
main:
    # SAVE ADDRESS
    # -----------------
    addu    $s7, $ra, $0     # Save address first to

loop:
    # PROMPT FOR P
    # -----------------
    la      $a0, prompt_p   # load 'prompt' data
    jal     input           # Call input()
    sw      $v0, p          # Store value to 'p'

    # CONDITION CHECK
    # -----------------
    lw      $t0, p          # Load 'p' to $to
    beqz    $t0, exit       # Branch to exit if zero

    # PROMPT N AND M
    # -----------------
    # Prompt for 'n'
    la      $a0, prompt_n   # load 'prompt_n' data
    jal     input           # Call input()
    sw      $v0, n          # Store value to 'n'
    
    # Prompt for 'm'
    la      $a0, prompt_m   # load 'prompt_m' data
    jal     input           # Call input()
    sw      $v0, m          # Store value to 'm'

    # FUNCTION CALL: extraExt()
    # -----------------
    lw      $a0, p          # Pass p
    lw      $a1, n          # Pass n
    lw      $a2, m          # Pass m
    jal     extraExt        # Call extraExt()
    move    $s0, $v0

    # OUTPUT
    # -----------------
    # Display unsigned
    jal     print_newline   # print newline

    li      $v0, 4          # print_str (system call 4)        
    la      $a0, unsigned   # Load 'unsigned' data
    syscall

    li      $v0, 1          # print_int (system call 1)
    move    $a0, $s0        # Copy the result from extraExt() to print
    syscall

    # Display signed
    # Load values
    lw      $t1, n          # Load n
    lw      $t2, max        # Total bits in a word
    sub     $t0, $t2, $t1   # 32 - n gives the number of bits left
    
    # Dynamic Shift for Sign Extension
    sll     $s0, $s0, $t0   # Ensure sign extension
    sra     $s0, $s0, $t0   # Return to position

    jal     print_newline   # print newline

    li      $v0, 4          # print_str (system call 4)        
    la      $a0, signed     # Load 'unsigned' data
    syscall

    li      $v0, 1          # print_int (system call 1)
    move    $a0, $s0        # Copy the result from extraExt() to print
    syscall

    # END
    # ----------------
    jal     print_newline   # print newline
    jal     print_newline   # print newline

    j       loop            # Continue

# Function: input(query)
# Params: query = message to pritn
# Desc: Takes a message as param
# Returns: Input from user
input:
    # Print prompt
    li      $v0, 4          # print_str (system call 4)   
    syscall

    # Get input from user
    li      $v0, 5          # read_int (system call 5)
    syscall
    
    jr      $ra             # Return to the caller

# Function: print_newline()
# Desc: Prints a new line
print_newline:
    li      $v0, 4          # print_str (system call 4)        
    la      $a0, endl       # Load 'endl' data
    syscall

    jr      $ra             # Return to caller

# Function: extraExt(p, n, m)
# Params: p = number to extract
#         n = length
#         m = starting bit
# Desc: Extracts the most significant 5 bits starting at position bit 3.
# Return: Extracted field
extraExt:
    # Save Stack
    sub     $sp, $sp, 16    # Make a space for three items
    sw      $ra, 12 ($sp)   # Save return address
    sw      $s0, 8 ($sp)    # Save register $s0
    sw      $s1, 4 ($sp)    # Save register $s1
    sw      $s2, 0 ($sp)    # Save register $s2

    # Copy arguments to save registers
    move    $s0, $a0        # Copy p to $s0
    move    $s1, $a1        # Copy n to $s1
    move    $s2, $a2        # Copy m to $s2

    # VALIDATE 
    # ----------------
    lw      $t0, max        # Load MAX 
    add     $t1, $s1, $s2   # $t1 = $s1 + $s2: Adding last two args
    bgt     $t1, $t0, max_error # Branch exit if the sum of $s1 + $s2 is greater than MAX.

    # MASKING PROCESS
    # -----------------
    move    $a0, $s1        # Pass n
    move    $a1, $s2        # Pass m
    jal     create_mask     # Call create_mask()
    move    $t0, $v0        # Load return value to $t0

    and     $s0, $t0, $s0   # Extract fields

    # Adjustments
    sra     $v0, $s0, $s2   # Reposition back to 0

    # Restore stack
    lw      $s2, 0 ($sp)    # Restore s2
    lw      $s1, 4 ($sp)    # Restore s1
    lw      $s0, 8 ($sp)    # Restore s0
    lw      $ra, 12 ($sp)   # Restore ra
    add     $sp, $sp, 16    # Free up stack

    jr      $ra             # Return to caller

# Function: create_mask(n, m)
# Params: n = length
#         m = starting bit position
# Desc: This function makes a mask based on n length and m bit position
# Return: Mask
create_mask:
    # Save stack
    sub     $sp, $sp, 8     # Make a space for one item
    sw      $ra, 4 ($sp)    # Save $ra
    sw      $s0, 0 ($sp)    # Save $s0

    # Setting up mask with n
    li      $s0, 1          # Starting mask
    sll     $s0, $s0, $a0   # Move bits to the left by n times.
    addu    $s0, $s0, -1    # Subtract by 1. The result should be the mask

    # Offsetting using m
    sll     $v0, $s0, $a1   # Finally, offset the mask by m bits.

    # Restore stack
    lw      $s0, 0 ($sp)    # Restore $s0
    lw      $ra, 4 ($sp)    # Restore $ra
    add     $sp, $sp, 8     # Free up stack

    jr      $ra             # Return to caller

max_error:
    li      $v0, 4          # print_str (system call 4)
    la      $a0, error      # Load 'max_error_msg'
    syscall

    jal     print_newline   # Print newline

    j       exit            # Jump exit

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