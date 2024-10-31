    .data
men_num: .asciiz "Introduzca num: " 
   
    .text
    .globl main
main:

    li $v0 4
    la $a0 men_num
    syscall

    li $v0 5 #servicio leer
    syscall 
    move $t0 $v0
    
    li $t1 0 #t1 = suma

loop:
    beqz $t0 final #Si t0!=0 salta
    andi $t3 $t0 1 #t3 = t0 & 1
    add $t1 $t1 $t3 #t1 = t1 + t3
    srl $t0 $t0 1 #t0 = t0 >> 1
    j loop

final:
    li $v0 1 #servicio print int
    move $a0 $t1
    syscall

    li $v0 10 #servicio exit
    syscall 