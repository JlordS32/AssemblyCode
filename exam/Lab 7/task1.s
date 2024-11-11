.data
query_msg: .asciiz "Enter p: "
unsigned_msg: .asciiz "Unsigned value: "
signed_msg: .asciiz "\nSigned value: "
p: .word 0

.text
.globl main
main:
    # RESTORE ADDRESS
    # ----------------------
    addu    $s7, $0, $ra        # Restore address

    jal     query               # Call query()
    move    $s0, $v0            # Store
    sw      $s0, p              # Store value to p

    # CALL extract()
    # ----------------------
    lw      $s0, p              # Load p
    move    $a0, $s0            # Pass p as param
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
    sll     $s1, $s1, 27        # Ensure sign extension
    sra     $s1, $s1, 27        # Return to position

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
    # Mask the value with mask 0xF8
    # 0x1F = 0001 1111 => 1111 1000 (if shifted by 5 bits to the left)
    li      $s1, 0x1f           # Mask to extract 5-bit
    sll     $s1, $s1, 3         # Move mask bits by 3 bit places to the left
    and     $s1, $s1, $a0       # Apply mask
    sra     $v0, $s1, 3         # srl LSB to bit 0 for unsign

    jr      $ra

query:

    li      $v0, 4              # print_str (syscall 4)
    la      $a0, query_msg      # Load 'query_msg' to print
    syscall

    li      $v0, 5              # read_int
    syscall

    jr      $ra 

exit_program:
    # RESTORE ADDRESS
    # ----------------------
    addu    $ra, $0, $s7        # Restore address
    jr      $ra                 # Return to caller
    nop
