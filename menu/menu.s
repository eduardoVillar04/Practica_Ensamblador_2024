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

msj_error:
        .asciiz "Valor de la selección incorrecto. Inténtelo de nuevo"
    .globl main
main:

loop:
#imprimir texto del menu
    li $v0 4
    la $a0 menu # imprimir menú
    syscall

    li $v0 12 # leer caracter
    lb $t0 $v0 # se guarda el carácter en t0

    # según la entrada del usuario, se llama a la función
    beq $t0, "H", leerHex
    beq $t0, "N", leerRGB
    beq $t0, "I", consulta
    beq $t0, "R", filtroR
    beq $t0, "V", filtroV
    beq $t0, "A", filtroA
    beq $t0, "Y", filtroY
    beq $t0, "C", filtroC
    beq $t0, "M", filtroM

    beq $t0, "S", exit # si el character es S se va a exit

    #imprimir texto del mensaje de error
    li $v0 4
    la $a0 msj_error # imprimir mensaje de error
    syscall

    #volver al bucle después del mensaje de error
    j loop
    
     # j loop -> ponerlo al final de cada función (se vuelve al bucle)

exit:
    li $v0 10 # salir del programa
    syscall


    