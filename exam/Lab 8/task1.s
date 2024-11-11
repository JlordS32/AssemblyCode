.data
query_N_msg: .asciiz "Enter N (0 - 20): "
query_T_msg: .asciiz "Enter T: "
query_t2_msg: .asciiz "Enter t2: "
error_msg: .asciiz "Error: Number not in range!\n"
T: .double 0.0
N: .double 0.0
t2: .double 0.0
MIN: .double 0.0
MAX: .double 20.0
result: .asciiz "\nSpeedup: "

.text
.globl main
main:
    # RESTORE ADDRESS
    # ----------------------
    addu    $s7, $0, $ra        # Restore address

    # QUERY
    # ----------------------
    # Query T
    la      $a0, query_T_msg
    jal     query               # Call query()
    s.d     $f0, T              # Save value to T

    # Query N
    jal     query_N             # Call query_N()
    s.d     $f0, N              # Save value to N

    # Query T
    la      $a0, query_t2_msg   
    jal     query               # Call query()
    s.d     $f0, t2             # Save value to t2

    # Load T, N and t2
    l.d     $f2, T
    l.d     $f4, N
    l.d     $f6, t2

    # Calculate Speed up
    sub.d   $f8, $f2, $f6       # t1 = T1 - t2 
    div.d   $f10, $f6, $f4      # t2' = t2 / N
    add.d   $f10, $f10, $f8     # T' = t1 + t2'
    div.d   $f12, $f2, $f10     # S = T / T'

    # PRINTING 
    li      $v0, 4              # print_str (syscall 4)
    la      $a0, result 
    syscall

    li      $v0, 3              # print_double (syscall 3)
    syscall

    j       exit_program

query:
    li      $v0, 4              # print_str (syscall 4)
    syscall

    li      $v0, 7              # read_int
    syscall

    jr      $ra

query_N:
    li      $v0, 4              # print_str (syscall 4)
    la      $a0, query_N_msg    # Load 'query_N_msg'
    syscall

    li      $v0, 7              # read_int
    syscall

    l.d     $f2, MIN            # Load MIN
    c.lt.d  $f0, $f2            # Check if $f0 > $f2
    bc1t    error               # If true branch error

    l.d     $f2, MAX            # Load MAX
    c.le.d  $f0, $f2            # Check if $f0 > $f2
    bc1f    error               # If false branch error

    jr      $ra 

error:
    li      $v0, 4              # print_str (syscall 4)
    la      $a0, error_msg      # Load 'error_msg' to print
    syscall

    j       query_N             # Jump back to query

exit_program:
    # RESTORE ADDRESS
    # ----------------------
    addu    $ra, $0, $s7        # Restore address
    jr      $ra                 # Return to caller
    nop
