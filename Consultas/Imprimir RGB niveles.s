.data
#color
actualColor:
actualBlue: .byte 254
actualGreen: .byte 27
actualRed: .byte 87
 .byte 0

#imprimir
inicio_niveles: .asciiz "RGB Niveles: "
coma: .asciiz ", "

.text
main:
    li $v0 4            #print string
    la $a0 inicio_niveles       #cargar el mensaje inicial
    syscall
     
    #cargar 255 como float
    li.s $f0 255.0

    #pasar los tres bytes a floats
    la $t0 actualRed
    lbu $t1 0($t0)
    mtc1 $t1 $f2         #f2 tiene el valor de rojo
    cvt.s.w $f2 $f2

    la $t0 actualGreen
    lbu $t1 0($t0)
    mtc1 $t1 $f3         #f3 tiene el valor de verde
    cvt.s.w $f3 $f3

    la $t0 actualBlue
    lbu $t1 0($t0)
    mtc1 $t1 $f4         #f4 tiene el valor de azul
    cvt.s.w $f4 $f4

    #dividir los valores por 255
    div.s $f2 $f2 $f0
    div.s $f3 $f3 $f0
    div.s $f4 $f4 $f0

    #imprimir
    li $v0 2         #print float
    mov.s $f12 $f2   #mover valor de rojo
    syscall

    li $v0 4        #print string
    la $a0 coma     #imprimir una coma
    syscall

    li $v0 2        #print float
    mov.s $f12 $f3   #mover valor de verde
    syscall

    li $v0 4        #print string
    la $a0 coma     #imprimir una coma
    syscall

    li $v0 2        #print float
    mov.s $f12 $f4   #mover valor de azul
    syscall

    #fin de programa
    li $v0 10
    syscall