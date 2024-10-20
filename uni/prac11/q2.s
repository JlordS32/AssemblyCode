# start of the main program
# this program can be used as a starting point to simulate logic
# circuits used to build ALU. It only implements one logic function.
# Author: Derek Bem, 2008

    .data
error_msg: .asciiz "Input must be 0 or 1!\n"
message1:  .asciiz "\n\nInput 0 or 1 for a: "  #string to print
message2:  .asciiz "Input 0 or 1 for b: "  #string to print
message3:  .asciiz "           a AND b: "  # string to print
message4:  .asciiz "\n---------------------" # next string to print

  .text
  .globl main
main:                        # main has to be a global label
    addu $s7, $0, $ra        # save the return address in a global register

#------------------------------------ getting a
get_a:
    li   $v0, 4              # print_string (system call 4)
    la   $a0, message1       # takes the address of string as an argument 
    syscall
  
    li   $v0, 5              # read_int (system call 5) 
    syscall          
    add  $s3, $0, $v0        # move to $s3
    
    li   $t0, 1
    bgt  $s3, $t0, error_message_a
    blt  $s3, $0, error_message_a

    j    get_b

error_message_a:
    li   $v0, 4
    la   $a0, error_msg
    syscall

    j    get_a

#------------------------------------ getting b
get_b:
    li   $v0, 4              # print_str (system call 4)
    la   $a0, message2       # takes the address of string as an argument 
    syscall
  
    li   $v0, 5              # read_int (system call 5)
    syscall          
    add  $s4, $0, $v0        # move to $s4


    li   $t0, 1              # load immediate 1 into $t0
    bgt  $s4, $t0, error_message_b  # if b > 1, go to error
    blt  $s4, $0, error_message_b    # if b < 0, go to error

    j    perform_and

error_message_b:
    li   $v0, 4
    la   $a0, error_msg
    syscall

    j    get_b

perform_and:
#----------------------------------- calculating (a AND b)
    and  $t0, $s3, $s4       # register $t0 contains (a AND b)

#----------------------------------- printing a AND b on the console
    li   $v0, 4              # print_str (system call 4)
    la   $a0, message3       # takes the address of string as an argument 
    syscall

    li   $v0, 1              # print_int (system call 1)
    add  $a0, $0, $t0        # put value to print in $a0
    syscall  

    li   $v0, 4              # print_str (system call 4)
    la   $a0, message4       # takes the address of string as an argument 
    syscall

    j  main                  # back to calculating  

exit:
#----------------------------------- usual stuff at the end of the main
    addu $ra, $0, $s7        # restore the return address
    jr   $ra                 # return to the main program