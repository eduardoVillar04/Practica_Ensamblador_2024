.data
actualColor:
actualBlue: .byte 0
actualGreen: .byte 0
actualRed: .byte 0
.byte 0 

.text
.globl main

main:

    li $v0 8    #llamada a leer string
    la $a0 $t0  #string se guarda en t0
    syscall

    li $t1 0    #iniciamos t0 a 0, sera donde se guardaran los valores de color
    li $t2 0    #iniciamos t1 a 0, nos servira para ir iterando sobre el string
    la $t3 $t0    #iniciamos t2 a 0, sera donde guardaremos la direccion de memoria a la que queremos acceder en cada bucle

while1:

    la $t3 ($t0)

    bnez 


fin1:




