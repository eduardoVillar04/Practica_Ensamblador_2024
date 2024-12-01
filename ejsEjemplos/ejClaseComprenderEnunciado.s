
main: jal rutina
    b final             #ra apunta a esta direccion

rutina:
    move $a0 $ra        #a0 = rutina -4
    la $t0 rutina       #t0 = rutina
    sub $t0 $t0 $a0     #t0  = (rutina)-(rutina-4) = 4 
    jr $ra

final:


########################################################################################


    .data
dato: .space 4

    .text
main:

    la $a0 dato
    li $t0 0x00     #dato : 0x00
    sb $t0 ($a0)
    add $a0 $a0 1   #dato+1 : 0x00
    sb $t0 ($a0)
    add $a0 $a0 1
    li $t0 0xFF     #dato+2 : 0xFF
    sb $t0 ($a0)
    add $a0 $a0 1
    li $t0 0x3F     #dato+3 : 0x3F
    sb $t0 ($a0)

    #cuanto vale el numero IEEE 754 que está en "dato"?
    #little endian -> 0x3FFF0000 -> 00111111 11111111 00000000 00000000
    #IEE 754 
    # S = +
    # E = 01111111 = 0
    # m = 1,1111111
    # resultado = 1'1111111 = 11111111 * 10^-111 = 255 / 2^7


########################################################################################

    .data
dato: .word 3FFF0000 (0000000000000000111111110011)
        #dato : 0x00
        #dato+1 : 0x00
        #dato+2 : 0xFF
        #dato+3 : 0x3F
    .text
main:
    la $t0 dato
    add $t0 $t0 1
    lb $a0 ($t0)

    #$a0 = 0x00