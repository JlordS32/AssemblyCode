.data
p_msg: .asciiz "Enter p: "
n_msg: .asciiz "Enter n: "
m_msg: .asciiz "Enter m: "
unsigned_msg: .asciiz "Unsigned value: "
signed_msg: .asciiz "\nSigned value: "
p: .word 0
n: .word 0
m: .word 0
MAX: .word 32
MIN: .word 1
error_max_msg: .asciiz "Error: n + m cannot exceed 32!\n\n"
error_min_msg: .asciiz "Error: n + m must be at least 1!\n\n"

.text
.globl main
main:
    # RESTORE ADDRESS
    # ----------------------
    addu    $s7, $0, $ra        # Restore address

    # QUERY
    # ----------------------
    # Query for p
    la      $a0, p_msg          # Load p_msg
    jal     query               # Call query()
    sw      $v0, p

query_nm:
    # Query for n
    la      $a0, n_msg          # Load n_msg
    jal     query               # Call query()
    sw      $v0, n

    # Query for m
    la      $a0, m_msg          # Load m_msg
    jal     query               # Call query()
    sw      $v0, m

    # VALIDATE n + m
    # ----------------------
    lw      $t0, n              # Load n
    lw      $t1, m              # Load m
    add     $t2, $t0, $t1       # n + m

    lw      $t3, MIN            # Load MAX value
    blt     $t2, $t3, error_min # Branch to error is less than 0
    lw      $t3, MAX            # Load MAX value
    bgt     $t2, $t3, error_max # If n + m > 32, branch as well

    # CALL extract()
    # ----------------------
    lw      $a0, p              # Load p
    lw      $a1, n              # Load n
    lw      $a2, m              # Load m
    jal     extract             # Call extract()
    move    $s1, $v0            # Store signed return value to $s1

    # PRINT
    # ----------------------

    # Display unsigned
    li      $v0, 4              # print_str (system call 4)        
    la      $a0, unsigned_msg   # Load 'unsigned' data
    syscall

    li      $v0, 1              # print_int (system call 1)
    move    $a0, $s1            # Copy the result from extract() to print
    syscall

    # Display signed
    lw      $t0, n              # Load n
    lw      $t1, MAX            # Load MAX
    sub     $t2, $t1, $t0       # MAX - n
    sll     $s1, $s1, $t2       # Ensure sign extension
    sra     $s1, $s1, $t2       # Return to position

    li      $v0, 4              # print_str (system call 4)        
    la      $a0, signed_msg     # Load 'unsigned' data
    syscall

    li      $v0, 1              # print_int (system call 1)
    move    $a0, $s1            # Copy the result from extract() to print
    syscall

    # EXIT
    # ----------------------
    j       exit_program

extract:
    # CREATE INITIAL MASK
    li      $s0, 1              # Load 1 into our starting mask
    sll     $s0, $s0, $a1       # Shift to left n times
    addi    $s0, $s0, -1        # Subtract by 1

    # REPOSITION to m bits
    sll     $s0, $s0, $a2       # Move to the left by m bit places
    
    # Performing masking
    and     $v0, $s0, $a0       # Return value 
    sra     $v0, $v0, $a2       # Return to bit 0

    jr      $ra

query:
    li      $v0, 4              # print_str (syscall 4)
    syscall

    li      $v0, 5              # read_int
    syscall

    jr      $ra 

error_min:
    li      $v0, 4              # print_str (syscall 4)
    la      $a0, error_min_msg  # Load 'error_min_msg'
    syscall

    j       query_nm

error_max:
    li      $v0, 4              # print_str (syscall 4)
    la      $a0, error_max_msg  # Load 'error_min_msg'
    syscall

    j       query_nm

exit_program:
    # RESTORE ADDRESS
    # ----------------------
    addu    $ra, $0, $s7        # Restore address
    jr      $ra                 # Return to caller
    nop
