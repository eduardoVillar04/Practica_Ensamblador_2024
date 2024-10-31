.data
string1: .asciiz "hola"

.text
.globl main

main:

    la $a0 string1
    move $t0 $a0
    li $v0 0

whil1:

    lb $t1 ($t0)
    beqz $t1 final
    addu $v0 $v0 1
    addu $t0 $t0 1

fin1:




