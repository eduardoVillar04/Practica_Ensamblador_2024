.text
.globl main

main:

    li $a0 5 #parametro funcion

    jal fact

    move $a0 $v0
    li $v0 1
    syscall

    move $a0 $v0
    li $v0 10
    syscall    


fact:

    #prologo
    subu $sp $sp 24
    sw $a0 20($sp) 
    sw $ra 4($sp)
    sw $s0 ($sp)

    bgtu $a0 1 mayor

    li $v0 1
    b finfac

mayor:
    move $s0 $a0
    subu $a0 $a0 1
    jal fact
    mul $v0 $s0 $v0

finfac:

    #epilogo
    lw $a0 20($sp)
    lw $ra 4($sp)
    lw $s0 ($sp)
    addu $sp $sp 24

    jr $ra
