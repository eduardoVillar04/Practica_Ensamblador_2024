.data
#color
actualColor:
actualBlue: .byte 75
actualGreen: .byte 90
actualRed: .byte 88
.byte 0

#imprimir
inicio_CMYK: .asciiz "CMYK: "
cian: .asciiz "C="
amarillo: .asciiz ", Y="
magenta: .asciiz ", M="
negro: .asciiz ", K="

.text
main:
    li $v0 4            #print string
    la $a0 inicio_CMYK       #cargar el mensaje inicial
    syscall

    #cargar 255 y 1 como floats
    li.s $f0 255.0
    li.s $f1 1.0

    #pasar los tres bytes a floats
    la $t0 actualRed
    lbu $t1 0($t0)
    mtc1 $t1 $f2            #f2 tiene el valor de rojo
    cvt.s.w $f2 $f2

    la $t0 actualGreen
    lbu $t1 0($t0)
    mtc1 $t1 $f3            #f3 tiene el valor de verde
    cvt.s.w $f3 $f3

    la $t0 actualBlue
    lbu $t1 0($t0)
    mtc1 $t1 $f4            #f4 tiene el valor de azul
    cvt.s.w $f4 $f4

    #obtener R', G' y B'
    div.s $f2 $f2 $f0       #R' = R/255
    div.s $f3 $f3 $f0       #G' = G/255
    div.s $f4 $f4 $f0       #B' = B/255

    #obtener max(R',G',B')
    mov.s $f5 $f2           #se asume que el maximo es R'
    c.le.s $f5 $f3          #if (R'< G')
    bc1t RMenorG
    c.le.s $f5 $f4          #if (R' >= G' && R'< B'), azul es mayor
    bc1t BMayor
    j ObtenerK              #rojo es el mayor
RMenorG:
    mov.s $f5 $f3           #ahora el mayor es G'
    c.le.s $f5 $f4          #if (G' < B'), azul es el mayor
    bc1t BMayor
    j ObtenerK              #verde es el mayor
BMayor:
    mov.s $f5 $f4
    j ObtenerK              #por si acaso

ObtenerK:
    sub.s $f5 $f1 $f5       #K = 1 - max(R',G',B')

    #obtener (1-K)
    sub.s $f6 $f1 $f5       #C M Y dividen por (1-K)

    #obtener C
    sub.s $f7 $f1 $f2       #1-R'
    sub.s $f7 $f7 $f5       #1-R'-K
    div.s $f7 $f7 $f6       #(1-R'-K) / (1-K)

    #obtener M
    sub.s $f8 $f1 $f3       #1-G'
    sub.s $f8 $f8 $f5       #1-G'-K
    div.s $f8 $f8 $f6       #(1-G'-K) / (1-K)

    #obtener Y
    sub.s $f9 $f1 $f4       #1-B'
    sub.s $f9 $f9 $f5       #1-B'-K
    div.s $f9 $f9 $f6       #(1-B'-K) / (1-K)

    #C en $f7, M en $f8, Y en $f9, K en $f5

    li $v0 4            #print string
    la $a0 cian         #imprimir "C="
    syscall
    li $v0 2            #print float
    mov.s $f12 $f7      #imprimir C
    syscall
    
    li $v0 4            #print string
    la $a0 magenta     #imprimir ", M="
    syscall
    li $v0 2            #print float
    mov.s $f12 $f8      #imprimir M
    syscall

    li $v0 4            #print string
    la $a0 amarillo     #imprimir ", Y="
    syscall
    li $v0 2            #print float
    mov.s $f12 $f9      #imprimir Y
    syscall

    li $v0 4            #print string
    la $a0 negro        #imprimir ", K="
    syscall
    li $v0 2            #print float
    mov.s $f12 $f5      #imprimir K
    syscall

    li $v0 10           #fin del sistema
    syscall
