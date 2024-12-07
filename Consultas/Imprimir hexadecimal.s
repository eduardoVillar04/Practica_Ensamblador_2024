.data
#color
actualColor:
    actualBlue: .byte 221 #0x11
    actualGreen: .byte 200 #0x2D
    actualRed: .byte 100 #0xFF
    .byte 0

h2iinicio: .asciiz "RGB: "
str_h2ierror: .asciiz "i2h_ERROR"
str_h2iresult:
    PrimerHex: .byte '0'
    SegundoHex: .byte '0'
    str_imphex_fin: .byte 0


.text
.globl main
main:
    li $v0 4            #print string
    la $a0 h2iinicio       #cargar el mensaje inicial
    syscall

    li $a1 3            #a1 sera el iterador
imphex_for:
    sub $a1 $a1 1       #for (i=2; i>=0;i--)
    la $a2 actualColor
    add $a2 $a2 $a1
    lbu $a0 ($a2)      #cargar el byte correcto
    
    jal i2h
    #incrementar el contador
    beqz $a1 imphex_fin
    j imphex_for

imphex_fin:
    li $v0 10
    syscall

i2h:
    #prologo
    subu $sp $sp 8
    sw $a0 4($sp)
    
    li $t0 16
    divu $a0 $t0      #dividir el numero por 16

    mflo $t2        #cociente
    mfhi $t3        #resto

IfCociente:
    blt $t2 10 CocienteElse_if
    bge $t2 16 i2h_error

    #10 <= cociente < 16
    sub $t2 $t2 10
    add $t2 $t2 'A'
    sb $t2 PrimerHex
    j IfResto

CocienteElse_if:
    #cociente < 10
    blt $t2 0 i2h_error
    
    #0 <= cociente < 10
    add $t2 $t2 '0'
    sb $t2 PrimerHex
    j IfResto

IfResto:
    blt $t3 10 RestoElseIf
    bge $t3 16 i2h_error

    #10 <= resto < 16
    sub $t3 $t3 10
    add $t3 $t3 'A'
    sb $t3 SegundoHex
    j imphex_fin_i2h

RestoElseIf:
    #resto < 10
    blt $t3 0 i2h_error

    #0 <= resto < 10
    add $t3 $t3 '0'
    sb $t3 SegundoHex
    j imphex_fin_i2h

i2h_error:
    li $v0 4
    la $a0 str_h2ierror
    syscall

    li $v0 10
    syscall

imphex_fin_i2h:
    li $v0 4
    la $a0 str_h2iresult
    syscall

    #epilogo
    lw $a0 4($sp)
    addu $sp $sp 8

    jr $ra