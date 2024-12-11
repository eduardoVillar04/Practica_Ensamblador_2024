.data
actualColor:
actualBlue: .byte 0
actualGreen: .byte 0
actualRed: .byte 0
.byte 0 

rgb_new_color:
newBlue: .byte 0
newGreen: .byte 0
newRed: .byte 0
.byte 0

str_error: .asciiz "ERROR"
str_red: .asciiz "INGRESA R [0,1]: "
str_green: .asciiz "INGRESA G [0,1]: "
str_blue: .asciiz "INGRESA B [0,1]: "

float_255: .float 255.0
float_0: .float 0.0
float_1: .float 1.0

.text
.globl main

main:

    l.s $f3 float_0              #cargamos 0 y 1 para hacer luego comparaciones
    l.s $f4 float_1
    l.s $f1 float_255               #cargamos 255 a f1 para multiplicar luego con él

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
    la $a0 str_error
    syscall

read_RGB_fin:

    lw $t0 rgb_new_color            #pasamos el color ingresado correctamente a actualColor
    sw $t0 actualColor

    li $v0 10
    syscall