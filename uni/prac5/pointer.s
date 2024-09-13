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
    lw      $a0, 0($t2)             # Load the value of $t2
    add     $t2, $t2, 4             # Move pointer to the next element

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