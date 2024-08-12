    # The main program is to perform calculation as per formula: __??
    # Note: A formula is a mathematical expression with variables. For this exercise, you need to declare some variables based on the calculation task.
    # Variable and expression are standard and common terms in programming context. It's assumed you have understood them from learning Programming Fundamentals.
    # places variables __?? ... __?? in registers __?? ... __??
    #                        |                           |
    #             list of variables          list of registers
    #
    #
.data
            .globl  message
message:    .asciiz "The value of f is: "       # message label containing a text inside the " "
extra:      .asciiz "\nHave a nice day :)"      # same as message label but has a new line at the beginning
thankyou:   .asciiz "\n\n\n ... Thank you :)"
            .align  2                           # align directive will be explained later

.text
            .globl  main
main:                                           # main has to be a global label
    addu    $s7,    $0,         $ra             # save return address in a global register

    # CALCULATING
    # For calculation tasks, add comments with a focus on algorithmic steps involved in the calculation.
    # Understand the concept of modeling and implementation in program context.

    addi    $s1,    $0,         15              # g = 15
    addi    $s2,    $0,         5               # h = 5
    addi    $s3,    $0,         30              # i = 30
    addi    $s4,    $0,         10              # j = 10
    addi    $s5,    $0,         3               # k = 3

    add     $t0,    $s1,        $s2             # g + h = 15 + 5 = 20
    add     $t1,    $s4,        $s5             # j + k = 13
    sub     $t2,    $s3,        $t1             # i - j + k = 30 - 13 = 17
    sub     $s0,    $t0,        $t2             # (g + h) - (i - j + k) = 20 - 17 = 3

    # PRINTING

    # print label "message"
    # li    $v0, 1              # ERROR
    li      $v0,    4                           # Correction to service call 4, to print string
    la      $a0,    message                     # load the label "message" to the argument register
    syscall

    # print integer value of $s0
    li      $v0,    1                           # service call 1 to print integers
    add     $a0,    $0,         $s0             # load the value of $s0 toe the argument register
    syscall

    # print label "extra"
    li      $v0,    4                           # service call 4 to print string
    la      $a0,    extra                       # load label "extra" to $a0
    syscall

    # print label "thankyou"
    li      $v0,    4
    la      $a0,    thankyou
    syscall

    # Usual stuff at the end of the main

    addu    $ra,    $0,         $s7             # restore the return address
    jr      $ra                                 # return to the main program
    add     $0,     $0,         $0              # nop (no operation)