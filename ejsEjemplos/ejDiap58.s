.text
.globl main
main:
    li $t1 4
    li $t2 2
    li $t0 8
    
    bne $t2 $t0 FIN
    li $t1 1

FIN: 