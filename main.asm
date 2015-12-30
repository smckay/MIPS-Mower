.data
buffer: .space 4000
buffer2: .space 50
fileName: .asciiz "landscape1.map"
moves: .asciiz "aaaaaassdssdwd"

.text
.globl main

main:
li $a0, 0xffff0000
la $a1, fileName
li $a2, 4000
jal arrayFill
 


li $a0, 0xffff0000
li $a1, 0x2F2B
li $a2, 25
li $a3, 80
jal find2Byte

li $a0, 0xffff0000
li $a1, 2
li $a2, 5
la $a3, moves
jal playGame

li $v0, 10
syscall


.include "mowerfunctions.asm"

