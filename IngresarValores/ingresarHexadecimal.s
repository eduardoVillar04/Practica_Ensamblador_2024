.data
actualColor:
actualBlue: .byte 0
actualGreen: .byte 0
actualRed: .byte 0
.byte 0 

str_buffer: .space 6
str_fin: .byte 0

str_error: .asciiz "ERROR"

.text
.globl main

main:

    li $v0 8                #llamada a leer string
    la $a0 str_buffer       #indicamos la direccion de memoria donde se guardara el str 
    #li $a1 6                #indicamos la longitud maxima del string
    syscall


    li $a0 0                #iniciamos a0 a 0, sera el valor del byte actual de color 
    li $a1 0                #iniciamos a1 a 0, sera donde se guardaran el valor total del color
    la $a2 str_buffer       #cargamos la direccion de memoria del str a a2

while1:

    lb $a0 ($a2)            #guardamos el valor del caracter correspondiente en a0
    beqz $a0 fin1           #si el caracter actual es 0, el bucle termina

    mul $a1 $a1 16        
    
    #llamamos a la funcion h2i para calcular el valor int del byte
    jal h2i
    
    add $a1 $a1 $v0

    addu $a2 1              #Sumamos 1 a la direccion de memoria para ir al siguiente byte

    j while1                #Repetimos bucle

fin1:

    sw $a1 actualColor      #Guardamos el resultado almacenado en $a1 en la direccion del color

    #IMRPIMIR POR PANTALLA: QUITAR
    li $v0 4
    lw $a0 actualColor
    syscall

    li $v0 10
    syscall

h2i:
    
    # #prologo
    # subu $sp $sp 24
    # sw $a0 20($sp) 
    # sw $ra 4($sp)
    # sw $s0 ($sp)

    #prologo
    subu $sp $sp 8
    sw $a0 4($sp)

    blt $a0 '0'else_if      #Si el char actual es menor que '0' no cumple los parametros y va al else_if
    bgt $t0 '9' else_if	    #Si el char actual es mayor que '9' no cumple los parametros y va al else_if
    
    # 0 <= char <= 9

    sub $v0 $a0 '0'

    j finh2i

else_if:

    blt $a0 'A' error       #Si el char actual es menor que 'A' no cumple los parametros y va al error
    bgt $t0 'F' error	    #Si el char actual es mayor que 'F' no cumple los parametros y va al error

    # 'A' <= char <= 'F'

    sub $v0 $a0 '9'

    j finh2i

error:

    li $v0 4
    la $a0 str_error
    syscall

    li $v0 10
    syscall


finh2i:

    # #epilogo
    # lw $a0 20($sp)
    # lw $ra 4($sp)
    # lw $s0 ($sp)
    # addu $sp $sp 24

    #prologo
    lw $a0 4($sp)
    addu $sp $sp 8

    jr $ra

