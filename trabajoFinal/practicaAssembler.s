    .data
# color
actualColor:
actualBlue: .byte 0
actualGreen: .byte 0
actualRed: .byte 0
.byte 0 

#color para lectura rgb
rgb_new_color:
newBlue: .byte 0
newGreen: .byte 0
newRed: .byte 0
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
msj_read_success: .asciiz "\n\nColor ingresado correctamente"
str_buffer: .space 6
str_fin: .byte 0

#read hex
str_read_hex: .asciiz "\n\nIngrese valor hexadecimal: "

#read float
str_red: .asciiz "INGRESA R [0,1]: "
str_green: .asciiz "INGRESA G [0,1]: "
str_blue: .asciiz "INGRESA B [0,1]: "
float_zero: .float 0.0
float_one: .float 1.0

#filters
RedFilter: .word 0x00FF0000
GreenFilter: .word 0x0000FF00
BlueFilter: .word 0x000000FF
YellowFilter: .word 0x00FFFF00
CyanFilter: .word 0x0000FFFF
MagentaFilter: .word 0x00FF00FF
msj_filter_success: .asciiz "\n\nFiltro aplicado correctamente"

#imprimir
h2iinicio: .asciiz "RGB: "
str_h2ierror: .asciiz "i2h_ERROR"
str_h2iresult:
    PrimerHex: .byte '0'
    SegundoHex: .byte '0'
    str_imphex_fin: .byte 0
inicio_componentes: .asciiz "RGB Componentes: "
inicio_niveles: .asciiz "RGB Niveles: "
inicio_CMYK: .asciiz "CMYK: "
cian: .asciiz "C="
amarillo: .asciiz ", Y="
magenta: .asciiz ", M="
negro: .asciiz ", K="
newline: .asciiz "\n"
coma: .asciiz ", "


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

    # salto de linea
    li $v0, 4          
    la $a0, newline    
    syscall         

    # comparar con las opciones del menú para hacer los saltos a las diferentes funciones

    beq $t0, 'S', salir # si es 'S' salir del programa

    beq $t0, 'H', leerHex
    beq $t0, 'N', leerRGB
    beq $t0, 'I', consulta
    beq $t0, 'R', filtroR
    beq $t0, 'V', filtroV
    beq $t0, 'A', filtroA
    beq $t0, 'Y', filtroY
    beq $t0, 'C', filtroC
    beq $t0, 'M', filtroM

    # mostrar mensaje de error si no coincide con ninguna opción
    li $v0, 4           
    la $a0, msj_error 
    syscall

    # volver al bucle principal
    j menu_loop

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

    #Se comunica al usuario que el numero ha sido ingresado
    la $a0 msj_read_success
    li $v0 4                       
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
    l.s $f3 float_zero              #cargamos 0 y 1 para hacer luego comparaciones
    l.s $f4 float_one
    mtc1 $t1 $f1                    #movemos el valor al coprocesador 
    cvt.s.w $f1 $f1                 #convertimos de int a float

    la $t2 newRed                   #guardamos la direccion de newRed en $t2
    la $t3 str_red                  #guardamos la direccion de str_red en $t3
    li $t4 0                        #guardamos 0 en $t4 para usarlo como contador


read_RGB_while:

    beq $t4 3 read_RGB_fin          #Si es la cuarta iteracion del string se termina

    la $a0 ($t3)                    #cargamos el string que corresponde segun el ciclo del bucle
    li $v0 4                        #escribimos string
    syscall

    li $v0 6                        #leemos float, se guarda en $f0
    syscall

    c.lt.s $f4 $f0                 #comprueba si 1 es menor que el valor ingresado (1<f0), si lo es activa la condition flag
    bc1t read_RGB_error            #si se ha activado la flag saltamos al error
    c.lt.s $f0 $f3                 #comprueba si el valor ingresado es menor que 0
    bc1t read_RGB_error   

    mul.s $f2 $f1 $f0               #multiplicamos el float del usuario por 255 (float)
    cvt.w.s $f2 $f2                 #pasamos el registro a integer
    mfc1 $t0 $f2                    #movemos el resultado al registro $t0

    sb $t0 ($t2)                    #guardamos valor en el byte que corresponda segun el ciclo del bucle
    
    sub $t2 $t2 1                   #restamos en 1 byte la direccion del color
    addi $t3 $t3 18                 #aumentamos en 18 bytes la direccion del str, que son su longitud
    addi $t4 1                      #sumamos 1 al contador
    j read_RGB_while

read_RGB_error:
    
    #Se comunica al usuario que ha habido un error
    li $v0 4
    la $a0 msj_error
    syscall

    j menu_loop

read_RGB_fin:

    lw $t0 rgb_new_color            #pasamos el color ingresado correctamente a actualColor
    sw $t0 actualColor

    #Se comunica al usuario que el numero ha sido ingresado
    li $v0 4
    la $a0 msj_read_success
    syscall

    j menu_loop

#------------------------------------------------------------------------------------------------------#

consulta:
    
    #Hexadecimal --------------------------------------------------------------------------------------------------------
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

imphex_fin:
   
    li $v0, 4          
    la $a0, newline    
    syscall      

    #RGB Componentes ----------------------------------------------------------------------------------------------------
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

    li $v0, 4          
    la $a0, newline    
    syscall            

    #RGB Niveles ----------------------------------------------------------------------------------------------------
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
    
    li $v0, 4          
    la $a0, newline    
    syscall

    #CMYK -------------------------------------------------------------------------------------------------------
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

    j menu_loop

#------------------------------------------------------------------------------------------------------#

filtroR:
    lw $t2 RedFilter # Le Decimos que el filtro es Rojo y Saltamos A Calcular
    jr calculate

filtroV:
    lw $t2 GreenFilter # Le Decimos que el filtro es Verde y Saltamos A Calcular
    jr calculate

filtroA:
    lw $t2 BlueFilter # Le Decimos que el filtro es Azul y Saltamos A Calcular
    jr calculate

filtroY:
    lw $t2 YellowFilter # Le Decimos que el filtro es Amarillo y Saltamos A Calcular
    jr calculate

filtroC:
    lw $t2 CyanFilter # Le Decimos que el filtro es Cyan y Saltamos A Calcular
    jr calculate

filtroM:
    lw $t2 MagentaFilter # Le Decimos que el filtro es Magenta y Saltamos A Calcular
    jr calculate

calculate:
    lw $t1 actualColor  # Cargamos el color a t1
    and $t1 $t1 $t2     # Hacemos un AND con el filtro y el color
    sw $t1 actualColor  # Cargamos el resultado a ActualColor

    #Se comunica al usuario que el filtro ha sido aplicado
    li $v0, 4                       
    la $a0, msj_filter_success
    syscall

    jr menu_loop

#------------------------------------------------------------------------------------------------------#
