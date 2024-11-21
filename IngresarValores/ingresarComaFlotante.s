.data
actualColor:
actualBlue: .byte 0
actualGreen: .byte 0
actualRed: .byte 0
.byte 0 

str_buffer: .space 6
str_fin: .byte 0

str_error: .asciiz "ERROR"

.text
.globl main

main:

    li $v0 6
    syscall