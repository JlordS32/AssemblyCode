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
message:  .asciiz "The value of f is: "   # __??
extra:    .asciiz "\nHave a nice day :)"  # __??
thankyou: .asciiz "\n\n\n ... Thank you :)"
  .align 2                  # align directive will be explained later

  .text
  .globl main
main:                       # main has to be a global label
  addu  $s7, $0, $ra        # save return address in a global register

# CALCULATING
# For calculation tasks, add comments with a focus on algorithmic steps involved in the calculation.
# Understand the concept of modeling and implementation in program context.
		
  addi  $s1, $0, 12         # __??
  addi  $s2, $0, -2         # __??
  addi  $s3, $0, 13         # __??
  addi  $s4, $0, 3          # __??
  add   $t0, $s1, $s2       # __??
  sub   $t1, $s3, $s4       # __??
  sub   $s0, $t0, $t1       # __??

        # PRINTING
        
        # print __??
  li    $v0, 4              # ERROR
  la    $a0, message        # __??
  syscall
  
        # print __??
  li    $v0, 1              # __??
  add   $a0, $0, $s0        # __??
  syscall
  
        # print __??
  li    $v0, 4              # ERROR
  la    $a0, extra          # __??
  syscall

  li    $v0, 4              
  la    $a0, thankyou          
  syscall
  
        # Usual stuff at the end of the main

  addu  $ra, $0, $s7        # restore the return address
  jr    $ra                 # return to the main program
  add   $0, $0, $0          # nop (no operation)