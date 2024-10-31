.text
.globl main
main:
    li $t0 5
    li $t1 7
    li $t2 8

    subi $t3 $t1 10
    mul $t3 $t3 $t0
    add $t3 $t3 $t2
    sub $t3 $0 $t3