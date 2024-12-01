    .data
menu:   .ascii  "\n\nPrograma COLORES\n"
        .ascii  "Pulse la inicial para seleccionar operación:\n\n"
        .ascii  "<H> Leer color en formato hexadecimal (ej: FF00FF)\n"
        .ascii  "<N> Leer color con niveles r-g-b (ej: 0.5 1.0 0.0)\n\n"
        .ascii  "<I> Consulta\n\n"
        .ascii  "<R> Aplicar filtro rojo\n"
        .ascii  "<V> Aplicar filtro verde\n"
        .ascii  "<A> Aplicar filtro azul\n"
        .ascii  "<Y> Aplicar filtro amarillo\n"
        .ascii  "<C> Aplicar filtro cian\n"
        .ascii  "<M> Aplicar filtro magenta\n\n"
        .asciiz  "<S> Salir\n\n"

# mensajes auxiliares
msj_error: .asciiz "\n\nValor de la selección incorrecto. Inténtelo de nuevo"
msj_prueba: .asciiz "\n\nholi"

.text
.globl main
main:
loop:
    # imprimir el menú
    li $v0, 4          
    la $a0, menu       
    syscall

    # leer un carácter del usuario
    li $v0, 12          # leer un carácter
    syscall
    move $t0, $v0       # guardar el carácter en $t0

    # comparar con las opciones del menú para hacer los saltos a las diferentes funciones

    beq $t0, 'S', salir # si es 'S' salir del programa

    la $t1, leerHex
    beq $t0, 'H', call
    la $t1, leerRGB
    beq $t0, 'N', call
    la $t1, consulta
    beq $t0, 'I', call
    la $t1, filtroR
    beq $t0, 'R', call
    la $t1, filtroV
    beq $t0, 'V', call
    la $t1, filtroA
    beq $t0, 'A', call
    la $t1, filtroY
    beq $t0, 'Y', call
    la $t1, filtroC
    beq $t0, 'C', call
    la $t1, filtroM
    beq $t0, 'M', call

    # mostrar mensaje de error si no coincide con ninguna opción
    li $v0, 4           
    la $a0, msj_error 
    syscall

    # volver al bucle principal
    j loop

# rutina para manejar saltos largos
call:
    jr $t1

# salida del programa
salir:
    li $v0, 10
    syscall

# funciones prueba
leerHex:
    li $v0, 4
    la $a0, msj_prueba
    syscall
    j loop

leerRGB:
    li $v0, 4
    la $a0, msj_prueba
    syscall
    j loop

consulta:
    li $v0, 4
    la $a0, msj_prueba
    syscall
    j loop

filtroA:
    li $v0, 4
    la $a0, msj_prueba
    syscall
    j loop

filtroC:
    li $v0, 4
    la $a0, msj_prueba
    syscall
    j loop

filtroM:
    li $v0, 4
    la $a0, msj_prueba
    syscall
    j loop

filtroR:
    li $v0, 4
    la $a0, msj_prueba
    syscall
    j loop

filtroV:
    li $v0, 4
    la $a0, msj_prueba
    syscall
    j loop

filtroY:
    li $v0, 4
    la $a0, msj_prueba
    syscall
    j loop