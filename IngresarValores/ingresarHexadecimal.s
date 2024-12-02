.data
actualColor:
actualBlue: .byte 0
actualGreen: .byte 0
actualRed: .byte 0
.byte 0 

# str_buffer: .space 6
# str_fin: .byte 0

str_error: .asciiz "ERROR"
str_read_hex: .asciiz "INGRESE VALOR HEXADECIMAL: "

str_buffer: .space 6
str_fin: .word 0

.text
.globl main

main:

    li $v0, 4               #mensaje pidiendo string
    la $a0, str_read_hex
    syscall

    li $v0 8                #llamada a leer string
    la $a0 str_buffer       #indicamos la direccion de memoria donde se guardara el str 
    li $a1 8                #indicamos la longitud maxima del string
    syscall


    li $a0 0                #iniciamos a0 a 0, sera el valor del byte actual de color 
    li $a1 0                #iniciamos a1 a 0, sera donde se guardaran el valor total del color
    la $a2 str_buffer       #cargamos la direccion de memoria del str a a2

read_hex_while:

    lb $a0 ($a2)            #guardamos el valor del caracter correspondiente en a0
    beq $a0 10 read_hex_fin         #si el caracter actual es 10 (LINE FEED), el bucle termina

    mul $a1 $a1 16        
    
    #llamamos a la funcion h2i para calcular el valor int del byte
    jal h2i
    
    add $a1 $a1 $v0

    addu $a2 1              #Sumamos 1 a la direccion de memoria para ir al siguiente byte

    j read_hex_while                #Repetimos bucle

read_hex_fin:

    sw $a1 actualColor      #Guardamos el resultado almacenado en $a1 en la direccion del color

    li $v0 10
    syscall

h2i:

    #prologo
    subu $sp $sp 8
    sw $a0 4($sp)

    blt $a0 '0' h2i_elif      #Si el char actual es menor que '0' no cumple los parametros y va al h2i_elif
    bgt $a0 '9' h2i_elif	  #Si el char actual es mayor que '9' no cumple los parametros y va al h2i_elif
    
    # 0 <= char <= 9

    sub $v0 $a0 '0'

    j finh2i

h2i_elif:

    blt $a0 'A' h2i_error       #Si el char actual es menor que 'A' no cumple los parametros y va al h2i_error
    bgt $a0 'F' h2i_error	    #Si el char actual es mayor que 'F' no cumple los parametros y va al h2i_error

    # 'A' <= char <= 'F'

    sub $v0 $a0 '7'

    j finh2i

h2i_error:

    li $v0 4
    la $a0 str_error
    syscall

    li $v0 10
    syscall


finh2i:

    #epilogo
    lw $a0 4($sp)
    addu $sp $sp 8

    jr $ra

