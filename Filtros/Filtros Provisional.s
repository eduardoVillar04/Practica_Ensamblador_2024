    .data
actualColor:
actualBlue: .byte 0xFF
actualGreen: .byte 0xFF
actualRed: .byte 0xFF
.byte 0 

RedFilter: .word 0x00FF0000
BlueFilter: .word 0x0000FF00
GreenFilter: .word 0x000000FF
YellowFilter: .word 0x00FFFF00
CyanFilter: .word 0x0000FFFF
MagentaFilter: .word 0x00FF00FF

    .text
main:

    # leer un carácter del usuario
    li $v0 12          # leer un carácter
    syscall
    move $t0 $v0       # guardar el carácter en $t0

    beq $t0 'R' RedInput # Comparacion a Salto si R es escrito
    beq $t0 'V' GreenInput # Comparacion a Salto si V es escrito
    beq $t0 'A' BlueInput # Comparacion a Salto si A es escrito
    beq $t0 'Y' YellowInput # Comparacion a Salto si Y es escrito
    beq $t0 'C' CyanInput # Comparacion a Salto si C es escrito
    beq $t0 'M' MagentaInput # Comparacion a Salto si M es escrito

RedInput:
    lw $t2 RedFilter # Le Decimos que el filtro es Rojo y Saltamos A Calcular
    jr calculate

GreenInput:
    lw $t2 GreenFilter # Le Decimos que el filtro es Verde y Saltamos A Calcular
    jr calculate

BlueInput:
    lw $t2 BlueFilter # Le Decimos que el filtro es Azul y Saltamos A Calcular
    jr calculate

YellowInput:
    lw $t2 YellowFilter # Le Decimos que el filtro es Amarillo y Saltamos A Calcular
    jr calculate

CyanInput:
    lw $t2 CyanFilter # Le Decimos que el filtro es Cyan y Saltamos A Calcular
    jr calculate

MagentaInput:
    lw $t2 MagentaFilter # Le Decimos que el filtro es Magenta y Saltamos A Calcular
    jr calculate

calculate:
    lw $t1 actualColor  # Cargamos el color a t1
    and $t1 $t1 $t2     # Hacemos un AND con el filtro y el color
    sw $t1 actualColor  # Cargamos el resultado a ActualColor
    jr main
