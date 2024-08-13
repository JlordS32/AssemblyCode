#-----------DATA-----------#
.data
.align 2 # Aligning values by the multiple of 4
k_query: .asciiz "Input value for k: "  # Storing the query string for k
m_query: .asciiz "Input value for m: "  # Storing the query string for m
result: .asciiz "Z[12] = " # Storing result string
Z: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15  # Initialising array
k: .word 0 # Defining k
m: .word 0 # Defining m

#-------MAIN PROGRAM--------#
.text
.globl main
main:
    #----------SAVE ADDRESS----------#
    addu    $s7, $0, $ra

    #---------QUERYING-----------#
    # Query user for k value
    li      $v0, 4          # Service call 4 to print string
    la      $a0, k_query    # Store address of "k_query" to $a0
    syscall

    li      $v0, 5          # Service call 5 = read integer
    syscall
    move    $s1, $v0        # Store word to $s1
    sw      $s1, k          # Store word to our defined variable "k" 

    # Query user for m value
    li      $v0, 4          # Service call 4 to print string
    la      $a0, m_query    # Store address of "m_query" to $a0
    syscall

    li      $v0, 5          # Service call 5 = read integer
    syscall
    move    $s2, $v0        # Store word to $s1
    sw      $s2, m          # Store word to our defined variable "m" 

    #---------CALCULATING-----------#
    li      $t0, 4          # Setting value at $t0 to calculate offset
    la      $s0, Z          # Loading the address of Z

    # Calculating the correct amount of offset
    mul     $t1, $s1, $t0   # Getting the offset value for Z[k]

    add     $t2, $s1, $s2   # Calculating k+m
    mul     $t2, $t2, $t0   # Getting the offset value for Z[k+m]

    # Getting the value with the calculated offset above
    add     $t3, $t1, $s0   # Get value of Z[k]
    lw      $s3, 0 ($t3)    # Load word 
    add     $t3, $t2, $s0   # Get value of Z[k+m]
    lw      $s4, 0 ($t3)    # Load word

    # Calculating the extracted values together 
    # Z[k] + Z[k+m] = ?? 
    add     $s5, $s3, $s4

    # Storing the final result to Z[12]
    sw      $s5, 48 ($s0)

    #--------PRINT SECTION----------#

    li      $v0, 4          # Service call 4 to print string
    la      $a0, result     # Loading "result" label to $a0
    syscall

    li      $v0, 1          # Service call 1 to print integer
    move    $a0, $s5        # Finally printing the result
    syscall

    #----------RESTORE ADDRESS----------#
    addu    $ra, $0, $s7
    jr      $ra
