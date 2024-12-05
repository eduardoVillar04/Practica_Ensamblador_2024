.data
#color
actualColor:
actualBlue: .byte 255
actualGreen: .byte 128
actualRed: .byte 50
 .byte 0

#imprimir
inicio_componentes: .asciiz "RGB Componentes: "
coma: .asciiz ", "

.text
main:

    li $v0 4            #print string
    la $a0 inicio_componentes       #cargar el mensaje inicial
    syscall

    li $v0 1            #print int
    lbu $a0 actualRed    #cargar el valor de rojo
    syscall
    
    li $v0 4             #print string
    la $a0 coma          #imprimir ", "
    syscall 

    li $v0 1             #print int
    lbu $a0 actualGreen   #cargar el valor de verde
    syscall

    li $v0 4             #print string
    la $a0 coma          #imprimir ", "
    syscall 

    li $v0 1             #print int
    lbu $a0 actualBlue    #cargar el valor de azul
    syscall

    li $v0 10            #fin de sistema
    syscall