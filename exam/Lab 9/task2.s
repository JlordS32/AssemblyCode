.data
msg:            .asciiz "Start entering characters (Buffer size 6):\n"
end:            .asciiz "\nPROGRAM TERMINATED...\n"
buffer_full_msg:.asciiz "\nBuffer is full, displaying contents:\n"
buffer:         .space 6          
buffer_size:    .word 6

.text
.globl main
main:
    # SAVE RETURN ADDRESS
    # --------------------
    addu    $s7, $0, $ra        # Save $ra to $s7

    # PRINT INITIAL MESSAGE
    # --------------------
    li      $v0, 4              # print_str
    la      $a0, msg            # Load address of 'msg'
    syscall 

    # SETUP MEMORY-MAPPED I/O BASE ADDRESS
    # --------------------
    li      $t0, 0xFFFF         # Load upper 16 bits
    sll     $t0, $t0, 16        # Shift left to get 0xFFFF0000

    # INITIALIZE BUFFER POINTER AND COUNTER
    # --------------------
    li      $t3, 0              # Counter for number of characters read
    la      $t2, buffer         # Buffer pointer (address of 'buffer')

read_loop:
    # READ CHARACTER FROM KEYBOARD
    # --------------------
    lw      $t1, 0($t0)         # Load Receiver Control Register
    andi    $t1, $t1, 0x0001    # Check Ready Bit (Bit 0)
    beq     $t1, $zero, read_loop  # If not ready, loop
    lb      $s0, 4($t0)         # Load character from Receiver Data Register

    # STORE CHARACTER IN BUFFER
    # --------------------
    sb      $s0, 0($t2)         # Store character in buffer
    addi    $t2, $t2, 1         # Increment buffer pointer
    addi    $t3, $t3, 1         # Increment character counter

    # CHECK IF BUFFER IS FULL
    # --------------------
    lw      $t4, buffer_size        # Buffer size
    beq     $t3, $t4, buffer_full   # If buffer is full, proceed

    j       read_loop           # Continue reading characters

buffer_full:
    # PRINT 
    # --------------------
    li      $v0, 4              # print_str
    la      $a0, buffer_full_msg    # Load address of 'buffer_full_msg'
    syscall 

    # RESET BUFFER POINTER
    # --------------------
    la      $t2, buffer         # Reset buffer pointer to start of 'buffer'
    li      $t3, 0              # Reset character counter

display_loop:
    # WAIT FOR TRANSMITTER TO BE READY
    # --------------------
    lw      $t1, 8 ($t0)        # Load Transmitter Control Register
    andi    $t1, $t1, 0x0001    # Check Ready Bit (Bit 0)
    beq     $t1, $zero, display_loop    # If not ready, loop

    # LOAD CHARACTER FROM BUFFER AND TRANSMIT
    # --------------------
    lb      $s0, 0 ($t2)        # Load character from buffer
    sb      $s0, 12 ($t0)       # Store character to Transmitter Data Register

    # INCREMENT BUFFER POINTER AND COUNTER
    # --------------------
    addi    $t2, $t2, 1         # Increment buffer pointer
    addi    $t3, $t3, 1         # Increment character counter

    # CHECK IF ALL CHARACTERS HAVE BEEN DISPLAYED
    # --------------------
    lw      $t4, buffer_size    # Buffer size
    bne     $t3, $t4, display_loop  # If not done, continue displaying

exit:
    # PRINT TERMINATION MESSAGE
    # --------------------
    li      $v0, 4              # print_str
    la      $a0, end            # Load address of 'end'
    syscall 

    # RESTORE RETURN ADDRESS
    # --------------------
    addu    $ra, $0, $s7        # Restore $ra from $s7
    jr      $ra                 # Return from main
    add     $0, $0, $0          # Nop