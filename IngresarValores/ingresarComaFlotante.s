.data
actualColor:
actualBlue: .byte 0
actualGreen: .byte 0
actualRed: .byte 0
.byte 0 

str_buffer: .space 6
str_fin: .byte 0

str_error: .asciiz "ERROR"
str_red: .asciiz "INGRESA R [0,1]: "
str_blue: .asciiz "INGRESA G [0,1]: "
str_green: .asciiz "INGRESA B [0,1]: "

.text
.globl main

main:


    li $t1 255                      #pasamos el 255 a float para poder multiplicar con el
    mtc1 $t1 $f1                    #movemos el valor al coprocesador 
    cvt.s.w $f1 $f1                 #convertimos de int a float

    la $t2 actualRed                #guardamos la direccion de actualBlue en $t2
    la $t3 str_red                  #guardamos la direccion de str_red en $t3
    li $t4 0                        #guardamos 0 en $t4 para usarlo como contador


while_f:

    beq $t4 3 fin                   #Si es la cuarta iteracion del string se termina

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
    j while_f

fin:

    li $v0 10
    syscall