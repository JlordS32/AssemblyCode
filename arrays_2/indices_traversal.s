.data
endl: .asciiz "\n"

.text
.globl main
main:
    # Load the example packet value into $s1
    li      $s1, 0xABCD1234    # Example packet value (Source Port = 0xABCD, Destination Port = 0x1234)

    # Extract Source Port (Bits 0-15)
    li      $t0, 0x0000FFFF    # Mask for Source Port (0xFFFF)
    and     $s2, $s1, $t0      # Apply mask to extract Source Port

    # Extract Destination Port (Bits 16-31)
    li      $t0, 0xFFFF0000    # Mask for Destination Port (0xFFFF0000)
    and     $s3, $s1, $t0      # Apply mask to extract Destination Port
    srl     $s3, $s3, 16       # Shift right to align bits 0-15 for Destination Port

    # Print the Source Port (Assuming system call 1 for integer print)
    li      $v0, 1             # Print integer syscall
    move    $a0, $s2           # Move Source Port to $a0
    syscall

    li      $v0, 4             
    la      $a0, endl           
    syscall

    # Print the Destination Port
    li      $v0, 1             # Print integer syscall
    move    $a0, $s3           # Move Destination Port to $a0
    syscall

    # Exit the program
    li      $v0, 10            # Exit syscall
    syscall
