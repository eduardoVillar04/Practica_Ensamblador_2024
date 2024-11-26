.data
#color
actualColor:
actualBlue: .byte 17
actualGreen: .byte 45
actualRed: .byte 255
 .byte 0

#imprimir
inicio: .asciiz "RGB Hexadecimal: "
coma: .asciiz ", "
#prueba
Red: .asciiz "FF"
Green: .asciiz "2D"
Blue: .asciiz "11"

.text
main:
    li $v0 4            #print string
    la $a0 inicio       #cargar el mensaje inicial
    syscall
ConvertirString:
#lo inverso de ingresar hexadecimal, estos son valores de prueba
    la $t0 Red
    la $t1 Green
    la $t2 Blue
Imprimir:
    li $v0 4            #print string
    move $a0 $t0          #cargar el valor de rojo
    syscall
    
    jal ImprimirComa

    li $v0 4            #print string
    move $a0 $t1          #cargar el valor de verde
    syscall

    jal ImprimirComa 

    li $v0 4             #print string
    move $a0 $t2          #cargar el valor de azul
    syscall

#No se si es posible hacerlo en solo un syscall 4, 
#pero al ser todo un string...

    li $v0 10            #fin de sistema
    syscall



ImprimirComa:
    li $v0 4             #print string
    la $a0 coma          #cargar ", " para imprimir
    syscall
    jr $ra               #volver a donde se ha llamado