    .data
# color
actualColor:
actualBlue: .byte 0
actualGreen: .byte 0
actualRed: .byte 0
.byte 0 

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
msj_prueba: .asciiz "\n\nPRUEBA"

#read
str_buffer: .space 6
str_fin: .byte 0
msj_read_success: .asciiz "\n\nColor ingresado correctamente"

#read hex
str_read_hex: .asciiz "\n\nIngrese valor hexadecimal: "
str_error: .asciiz "ERROR"

#read float
str_red: .asciiz "INGRESA R [0,1]: "
str_blue: .asciiz "INGRESA G [0,1]: "
str_green: .asciiz "INGRESA B [0,1]: "


    .text
    .globl main
main:
menu_loop:
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
    j menu_loop

# rutina para manejar saltos largos
call:
    jr $t1

# salida del programa
salir:
    li $v0, 10
    syscall

# funciones

#------------------------------------------------------------------------------------------------------#
leerHex:

    li $v0, 4               #mensaje pidiendo string
    la $a0, str_read_hex
    syscall

    li $v0 8                #llamada a leer string
    la $a0 str_buffer       #indicamos la direccion de memoria donde se guardara el str 
    li $a1 8                #indicamos la longitud maxima del string
    syscall


    li $a0 0                #iniciamos a0 a 0, sera el valor del byte actual de color 
    li $a1 0                #iniciamos a1 a 0, sera donde se guardaran el valor total del color
    la $a2 str_buffer       #cargamos la direccion de memoria del str a a2

read_hex_while:

    lb $a0 ($a2)                    #guardamos el valor del caracter correspondiente en a0
    beq $a0 10 read_hex_fin         #si el caracter actual es 10 (LINE FEED), el bucle termina

    mul $a1 $a1 16        
    
    #llamamos a la funcion h2i para calcular el valor int del byte
    jal h2i
    
    add $a1 $a1 $v0

    addu $a2 1                      #Sumamos 1 a la direccion de memoria para ir al siguiente byte

    j read_hex_while                #Repetimos bucle

read_hex_fin:

    sw $a1 actualColor              #Guardamos el resultado almacenado en $a1 en la direccion del color

    li $v0, 4                       #Se comunica al usuario que el color ha sido guardado
    la $a0, msj_read_success
    syscall

    # volver al bucle principal
    j menu_loop

h2i:

    #prologo
    subu $sp $sp 8
    sw $a0 4($sp)

    blt $a0 '0' h2i_elif      #Si el char actual es menor que '0' no cumple los parametros y va al h2i_elif
    bgt $a0 '9' h2i_elif	  #Si el char actual es mayor que '9' no cumple los parametros y va al h2i_elif
    
    # 0 <= char <= 9

    sub $v0 $a0 '0'

    j finh2i

h2i_elif:

    blt $a0 'A' h2i_error       #Si el char actual es menor que 'A' no cumple los parametros y va al h2i_error
    bgt $a0 'F' h2i_error	    #Si el char actual es mayor que 'F' no cumple los parametros y va al h2i_error

    # 'A' <= char <= 'F'

    sub $v0 $a0 '7'

    j finh2i

h2i_error:

    li $v0 4
    la $a0 msj_error
    syscall

    j menu_loop

finh2i:

    #epilogo
    lw $a0 4($sp)
    addu $sp $sp 8

    jr $ra

#------------------------------------------------------------------------------------------------------#

leerRGB:
    
    li $t1 255                      #pasamos el 255 a float para poder multiplicar con el
    mtc1 $t1 $f1                    #movemos el valor al coprocesador 
    cvt.s.w $f1 $f1                 #convertimos de int a float

    la $t2 actualRed                #guardamos la direccion de actualBlue en $t2
    la $t3 str_red                  #guardamos la direccion de str_red en $t3
    li $t4 0                        #guardamos 0 en $t4 para usarlo como contador


read_RGB_while:

    beq $t4 3 read_RGB_fin          #Si es la cuarta iteracion del string se termina

    la $a0 ($t3)                    #cargamos el string que corresponde segun el ciclo del bucle
    li $v0 4                        #escribimos string
    syscall

    li $v0 6                        #leemos float, se guarda en $f0
    syscall

    mul.s $f2 $f1 $f0               #multiplicamos el float del usuario por 255 (float)
    cvt.w.s $f2 $f2                 #pasamos el registro a integer
    mfc1 $t0 $f2                    #movemos el resultado al registro $t0

    sb $t0 ($t2)                    #guardamos valor en el byte que corresponda segun el ciclo del bucle
    
    sub $t2 $t2 1                   #restamos en 1 byte la direccion del color
    addi $t3 $t3 18                 #aumentamos en 18 bytes la direccion del str, que son su longitud
    addi $t4 1                      #sumamos 1 al contador
    j read_RGB_while

read_RGB_fin:

    li $v0 4
    la $a0 msj_read_success
    syscall

    j menu_loop

#------------------------------------------------------------------------------------------------------#

consulta:
    li $v0, 4
    la $a0, msj_prueba
    syscall
    j menu_loop

#------------------------------------------------------------------------------------------------------#

filtroA:
    li $v0, 4
    la $a0, msj_prueba
    syscall
    j menu_loop

#------------------------------------------------------------------------------------------------------#

filtroC:
    li $v0, 4
    la $a0, msj_prueba
    syscall
    j menu_loop

#------------------------------------------------------------------------------------------------------#

filtroM:
    li $v0, 4
    la $a0, msj_prueba
    syscall
    j menu_loop

#------------------------------------------------------------------------------------------------------#

filtroR:
    li $v0, 4
    la $a0, msj_prueba
    syscall
    j menu_loop

#------------------------------------------------------------------------------------------------------#

filtroV:
    li $v0, 4
    la $a0, msj_prueba
    syscall
    j menu_loop

#------------------------------------------------------------------------------------------------------#

filtroY:
    li $v0, 4
    la $a0, msj_prueba
    syscall
    j menu_loop

#------------------------------------------------------------------------------------------------------#
