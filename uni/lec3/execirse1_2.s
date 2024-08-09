.data
array:  .word   1, 29, 34, 69, 5

.text
main:

    # Store array
    la      $s6,    array

    # Load value of the i = 0
    lw      $t0,    4($s6)          # Offsetting array by i * 4

    # Accessing array[i] directly
    li      $t1,    8               # Set index, i = 2
    add     $t1,    $t1,        $s6 # Get the memory address of the value directly
    lw      $t2,    0($t1)          # Load word

    # Accessing "array" label directly
    li      $t3,    12
    lw      $t4,    array($t3)

    li      $v0,    10
    syscall
