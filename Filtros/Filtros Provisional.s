.data
RedFilter:0x00FF0000
BlueFilter:0x0000FF00
GreenFilter:0x000000FF
YellowFilter:0x00FFFF00
CyanFilter:0x0000FFFF
MagentaFilter:0x00FF00FF

main:
li $a1 1
li $v0 8
syscall
move $n0 $a0
beq $n0 'R' RedInput # Comparacion a Salto si R es escrito
beq $n0 'V' GreenInput # Comparacion a Salto si V es escrito
beq $n0 'A' BlueInput # Comparacion a Salto si A es escrito
beq $n0 'Y' YellowInput # Comparacion a Salto si Y es escrito
beq $n0 'C' CyanInput # Comparacion a Salto si C es escrito
beq $n0 'M' MagentaInput # Comparacion a Salto si M es escrito

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
 and $t1 $t2 # Hacemos un AND con el filtro y el color
 jr main
