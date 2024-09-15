.data
query: .asciiz "Enter a number: "
result: .asciiz "Result: "

.text
.globl main
main:

    # SAVE RETURN ADDRESS
    move    $s7, $ra

    # QUERY USER FOR FIRST NUMBER
    jal     query_user
    move    $t0, $v0

    # QUERY USER FOR SECOND NUMBER
    jal     query_user
    move    $t1, $v0

    # Start operation (add numbers)
    move    $a0, $t0
    move    $a1, $t1
    jal     add_num           # Add the numbers; result will be in $v0

    # Output result
    move    $a0, $v0          # Move the result to $a0 for printing
    jal     output

    # RESTORE RETURN ADDRESS
    move    $ra, $s7
    jr      $ra

query_user:
    # Print query
    li      $v0, 4
    la      $a0, query
    syscall

    # Read user input (double-precision floating-point)
    li      $v0, 5
    syscall

    # Return input in $f0 (the result is in $f0 and $f1, but $f0 is used here)
    jr      $ra

output:
    move    $t0, $a0

    # Print result string
    li      $v0, 4
    la      $a0, result
    syscall

    # Print result value (in $a0)
    li      $v0, 1
    move    $a0, $t0
    syscall

    jr      $ra

add_num:
    mtc1    $a0, $f12
    mtc1    $a1, $f14         
    cvt.d.w $f12, $f12        
    cvt.d.w $f14, $f14        
    
    add.d   $f0, $f12, $f14    
    
    cvt.w.d $f0, $f0        
    mfc1    $v0, $f0        
    jr      $ra            
