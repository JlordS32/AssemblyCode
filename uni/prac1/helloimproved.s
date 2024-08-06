# improved version of 'hello.s'
# start of the main program to print "Hello, have a nice day."

  .text
  .globl main
main:                    # main has to be a global label
  addu $s7, $0, $ra      # save the return address in a register
	
#------------Output the string "Hello, have a nice day." on a separate line 
  .data
label1:	.asciiz "\nHello, have a nice day.\n"    #string to print
helloWorld: .asciiz "Hello World!\n"
name: .asciiz "My name is Jaylou"

  .text
  li $v0, 4              # print_str (system call 4) 
                         
  la $a0, label1         # takes string address as an argument
  syscall

  la $a0, helloWorld     # print helloWorld
  syscall 

  la $a0, name           # print name
  syscall

#------------Usual stuff at the end of the main
  addu	$ra, $0, $s7     # restore the return address
  jr $ra                 # return to the main program
  add $0, $0, $0         # nop (does not do anything here)
