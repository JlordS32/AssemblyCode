.data
ControlReg: .word   0xFFFF0000              # Address of the Control Register
DataReg:    .word   0xFFFF0004              # Address of the Data Register

.text
main:
    # Polling loop
Waitloop:
    lw      $t0,    ControlReg              # Load the value of the Control Register

    andi    $t0,    $t0,        0x0001      # Check the Ready bit (bit-0)

    beq     $t0,    $zero,      Waitloop    # If not ready, keep polling

    # Device is ready, read data from the Data Register
    lw      $t1,    DataReg                 # Load data from the Data Register

    # (Optional) Process the data in $t1 here
    li      $v0,    1
    move      $a0,    $t1
    syscall

    # Exit the program (assuming a syscall for exit)
    li      $v0,    10                      # Load the exit syscall code
    syscall