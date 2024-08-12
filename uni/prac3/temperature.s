    # this programs asks for temperature in Fahrenheit
    # and converts it to Celsius

.text
        .globl  main
main:                                                   # main has to be a global label
    addu    $s7,    $0,     $ra                         # save return address in a global register


    # GETTING INPUT VALUE

    la      $a0,    input                               # print message "input" on the console
    li      $v0,    4
    syscall

    # Syscall 5 to read integer
    li      $v0,    5
    syscall

    # CALCULATING

    addi    $t0,    $v0,    -32                         # Compute -32 + the input stored at $v0.
    mul     $t0,    $t0,    5                           # Multiply the computed value by 5
    div     $t0,    $t0,    9                           # Divide the result by 9

    # PRINTING

    la      $a0,    result                              # Assign the memory address of the label "result"
    li      $v0,    4                                   # Syscall 4 to print string
    syscall                                             # Initiate syscall

    move    $a0,    $t0                                 # Copy the value of $t0 to the argument register $a0
    li      $v0,    1                                   # Sycall 1 to print integer
    syscall                                             # Initiate syscall

.data
input:  .asciiz "\n\nEnter temperature in Fahrenheit: "
result: .asciiz "The temperature in Celsius is: "

.text
    addu    $ra,    $0,     $s7                         # restore the return address
    jr      $ra                                         # return to the main program
    add     $0,     $0,     $0                          # nop (no operation)