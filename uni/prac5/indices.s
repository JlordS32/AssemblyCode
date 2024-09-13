.data
array: .word 10, 20, 30, 40, 50     # Array of 5 elements
size:  .word 5                      # Size of the array

.text
.globl main
main:
    addu    $s7, $0, $ra

    lw      $t0, size               # $t0 = size (number of elements)
    li      $t1, 0                  # $t1 = index (start at 0)
    la      $t2, array              # $t2 = base address of the array

index_loop:
    beq     $t1, $t0, end_index     # Exit loop when index equals size

    # Access array element using index
    sll     $t3, $t1, 2             # $t3 = offset = index * 4 (each element is 4 bytes)
    add     $t4, $t2, $t3           # Get address of the current element
    lw      $a0, 0($t4)             # Load the value into $a0 to print

    # Print the value
    li      $v0, 1
    syscall

    # Move to the next element
    addi    $t1, $t1, 1           # index++

    j       index_loop

end_index:
    
    addu    $ra, $0, $s7
    jr      $ra
    add     $0, $0, $0