    .text
    .globl main

    # x^3 + 6x^2 · y + 12 · x · y^2 + 8 · y^3
    # s0  = x
    # s1  = y
    # s2 = s0^3 + 6s0^2 · s1 + 12 · s0 · s1^2 + 8 · s1^3

main:

    li $s0 2
    li $s1 3

    mul $s2 $s0 $s0 #s2 = s0^2
    mul $s2 $s2 $s0 #s2 = s0^3

    mul $t0 $s0 $s0 #t0 = s0^2
    mul $t0 $t0 6   #t0 = 6 · s0^2
    mul $t0 $t0 $s1 #t0 = 6 · s0^2 · s1

    mul $t1 $s0 12  #t1 = 12 · s0
    mul $t1 $t1 $s1 #t1 = 12 · s0 · s1
    mul $t1 $t1 $s1 #t1 = 12 · s0 · s1^2

    mul $t2 $s1 $s1 #t2 = s1^2
    mul $t2 $t2 $s1 #t2 = s1^3
    mul $t2 $t2 8   #t2 = 8 · s1^3

    add $s2 $s2 $t0 #s2 = s2 + t0 = s0^3 + 6 · s0^2 · s1
    add $s2 $s2 $t1 #s2 = s2 + t1 = s0^3 + 6 · s0^2 · s1 + 12 · s0 · s1^2 
    add $s2 $s2 $t2 #s2 = s2 + t2 = s0^3 + 6 · s0^2 · s1 + 12 · s0 · s1^2 + 8 · s1^3

    li $v0 1        #servicio print int
    move $a0 $s2
    syscall

    li $v0 10       #servicio exit
    syscall 