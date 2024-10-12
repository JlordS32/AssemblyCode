# This program implements:
#	sum = 0;
#	i = 9;
#	do {
#		sum = sum + A[9-i]
#		B[9-i] = sum;
#		i--;
#	}
#	until (i = 0) 
	.globl main	
main:
	add		$t2, $0, $0		# sum = 0  (sum is in $t2)
	la      $t1, A

	# FIRST 3 BAD ADDRESS EXCEPTIONS
	# ------------------------------
	# Issue: Loading not in range of $t1
	lw		$t4, Four	    # Constant 4 stored in $t4
	lw		$t0, Nine	    # Constant 9 stored in $t0 (i)
	lw		$t5, Minus1	    # Constant -1 stored in $t5
	# ------------------------------

	add		$t1, $t1, $t4 	# A starts at 4 (move $t1 to point to A)

loop:
	# 4TH BAD ADDRESS EXCEPTION
	# ------------------------------
	# Issue: The instruction points to an invalid
	# address.
	lw		$t3, 0($t1)		# $t3 has A[k]
	# ------------------------------

	add		$t2, $t2, $t3	# sum = sum + A[k]
	
	# 5TH BAD ADDRESS EXCEPTION
	# ------------------------------
	# Issue: The instruction points to an invalid
	# address.
	sw		$t2, 40($t1)	# B[k] = sum
	# ------------------------------

	add		$t1, $t1, $t4	# update address pointer
	add		$t0, $t0, $t5	# i--
	beq		$t0, $0, done   # if i = 0 go to done

	j		loop			# if i &gt; 0 go to loop
	
done:	
	add		$t1, $0, $0		# Set $t1 to point to beginning of data
	
	# 6TH BAD ADDRESS EXCEPTION
	# ------------------------------
	# Issue: The instruction points to an invalid
	# address.
	sw		$t2, sum
	# ------------------------------

	li		$v0, 4			# print_str
	la		$a0, message	# load address of string 
	syscall				#

	li		$v0, 1			# print_int
	lw		$a0, sum		# load integer value
	syscall				

	jr		$ra				# return to the main program
	add		$0, $0, $0		# nop

	.data
sum:		.word	0
A:			.word 	0, 1, 2, 3, 4, 5, 6, 7, 8, 9
B:			.word	0, 0, 0, 0, 0, 0, 0, 0, 0, 0
message:	.asciiz	"\nThe value of sum is:  "
Four:		.word	4
Nine:		.word	9
Minus1:		.word	-1