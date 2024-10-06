.data
msg: .asciiz "Enter any characters (Press 'Enter' to exit):\n"
terminator: .asciiz "\n"
end: .ascii "\nPROGRAM TERMINATED...\n"

.text
main:
    # SAVE ADDRESS
    # --------------------
    addu    $s7, $0, $ra        # Save $ra to $s7

    # PRINT
    # --------------------
    li      $v0, 4              # print_str (syscall 4)
    la      $a0, msg            # Load 'msg' data
    syscall 

    # START OPERATION
    # --------------------
    # Get address 0xffff0000 for Receiver Control
    li      $t0, 0xffff         # Load receiver control address
    sll     $t0, $t0, 16        # Move bits to 16 to get address

read_loop:

    # READ CHARACTER
    # --------------------
    lw      $t1, 0 ($t0)        # Load $t0 to $t1
    andi    $t1, $t1, 0x0001    # Check if ready
    beq     $t1, $0, read_loop  # Loop if zero
    lb      $s0, 4 ($t0)        # Get receiver data

    # VALIDATE CHARACTER
    # --------------------
    lbu     $s1, terminator     # Get terminator
    beq     $s0, $s1, exit      # Exit if receiver data '\n'

write_loop:

    lw      $t1, 8($t0)         # Load transmitter control
    andi    $t1, $t1, 0x0001    # Check if ready
    beq     $t1, $0, write_loop # Loop if not ready
    sw      $s0, 12($t0)        # transmit data
    j  read_loop                # continue

exit:
    # PRINT
    # --------------------
    li      $v0, 4              # print_str (syscall 4)
    la      $a0, end            # Load 'end' data
    syscall 

    # RESTORE ADDRESS
    # --------------------
    addu    $ra, $0, $s7        # Restore address from $s7
    jr      $ra                 # Return 
    add     $0, $0, $0          # Nop
