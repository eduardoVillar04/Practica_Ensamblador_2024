.data
#color
actualColor:
actualBlue: .byte 0
actualGreen: .byte 0
actualRed: .byte 0
 .byte 0

#imprimir
inicio: .asciiz "RGB Componentes: "
coma: .asciiz ", "

.text
main:
    li $v0 4            #print string
    la $a0 inicio       #cargar el mensaje inicial
    syscall

    li $v0 1            #print int
    lb $a0 actualRed    #cargar el valor de rojo
    syscall
    
    jal ImprimirComa

    li $v0 1             #print int
    lb $a0 actualGreen   #cargar el valor de verde
    syscall

    jal ImprimirComa 

    li $v0 1             #print int
    lb $a0 actualBlue    #cargar el valor de azul
    syscall

    li $v0 10            #fin de sistema
    syscall

ImprimirComa:
    li $v0 4             #print string
    la $a0 coma          #cargar ", " para imprimir
    syscall
    jr $ra               #volver a donde se estaba
