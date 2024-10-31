.data

dato:   .word 0xabcd12bd

    .text
    .globl main

main:
    lw $t0 dato
    li $t1 0xFFFFFFEB

    and $t2 $t1 $t0
    sw $t2 dato

    li $v0 10
    syscall