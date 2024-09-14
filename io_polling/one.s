
.kdata
save0:  .word   0                       # Storage for $a0
save1:  .word   0                       # Storage for $a1
error:  .asciiz "Some fucking message"

.ktext  0x80000180              # Start of the kernel text section
.globl main
main:
    # Preserved the code state at $k1
    move    $k1,        $at             # Save $at register

    # Get the values of save0 and save1 and stoer in the 
    # two argument registers.
    sw      $a0,        save0           # Handler is not re-entrant and can’t use $at
    sw      $a1,        save1           # Stack to save $a0, $a1

    # Move Cause register into $k0
    mfc0    $k0,        $13             # Copy Cause into $k0

    # Setting up the mask
    srl     $a0,        $k0,    2       # ExCode at 6-2 bit places. We shift to the right.
    andi    $a0,        $a0,    0xf     # Mask to get the relevant bits. 0000 1111

    bgtz    $a0,        done            # Branch if ExcCode is Int (0)

    move    $a0,        $k0             # Move Cause into $a0
    mfc0    $a1,        $14             # Move EPC into $a1

    j       print                      # Print exception error message

done:
    mfc0    $k0,        $14             # Bump EPC

    addiu   $k0,        $k0,    4       # Do not reexecute faulting instruction

    mtc0    $k0,        $14             # EPC
    mtc0    $0,         $13             # Clear Cause register

    mfc0    $k0,        $12             # Fix Status register
    andi    $k0,        $k0,    0xfffd  # Clear EXL bit

    ori     $k0,        $k0,    0x1     # Enable interrupts
    
    mtc0    $k0,        $12             # Update Status register
    lw      $a0,        save0           # Restore registers
    lw      $a1,        save1

    move    $at,        $k1             # Restore $at register

