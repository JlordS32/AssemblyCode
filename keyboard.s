.data
    prompt: .asciiz "Press a key: "
    newline: .asciiz "\n"

.text
    main:
        # Print the prompt
        li $v0, 4          # Load the syscall code for print_str
        la $a0, prompt     # Load address of the prompt string
        syscall            # Make the syscall

        # Read a character
        li $v0, 12         # Load the syscall code for read_char
        syscall            # Make the syscall
        move $t0, $v0      # Move the read character to $t0

        # Exit the program
        li $v0, 10         # Load the syscall code for exit
        syscall            # Make the syscall
