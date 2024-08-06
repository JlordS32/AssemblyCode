.data
mess: .asciiz "\nThe value of f is: "

.text
.globl main
main:

    addu        $s7, $0, $ra

    addi $s1,$0,5       # $s1 <= 5 <=> s1=5; (C-like)
    addi $s2,$0,-20     # $s2 <= -20 <=> s2=-20;
    addi $s3,$0,13      # $s3 <= 13 <=> s3=13;
    addi $s4,$0,3       # $s4 <= 3 <=> s4=3;

    add $t0,$s1,$s2     # 5 – 20 <=> t0=s1+s2;
    add $t1,$s3,$s4     # 13 + 3 <=> t1=s3+s4;

    sub $s0,$t0,$t1     # ? = (5 - 20) - (13 + 3)

    li $v0,4            # HP_AppA.pdf Page 44 or Appendix B in HP4
    la $a0,mess         # . . .
    syscall
    
    li $v0,1            
    add $a0,$0,$s0     
    syscall

    addu        $ra, $0, $s7
    jr          $ra