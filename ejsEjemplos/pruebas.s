    .text
    .globl main

    # x^3 + 6x^2 · y + 12 · x · y^2 + 8 · y^3
    # s0  = x
    # s1  = y
    # s2 = s0^3 + 6s0^2 · s1 + 12 · s0 · s1^2 + 8 · s1^3

main:

    li $v0 5 #servicio leer
    syscall 
    move $t0 $v0
    
    li $v0 1        #servicio print int
    move $a0 $t0
    syscall

    li $v0 10       #servicio exit
    syscall 