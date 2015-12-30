
.text

##############################
# Part 1 FUNCTION
##############################


#$a0 = base address of array in memory
#$a1 = address of filename in memory
#$a2 = max number of bytes to read 
#$v0 = number of bytes read and stored, -1 if an error occurs 
arrayFill:
	#Define your code here
	move $t0, $a0
	move $t1, $a1
	move $t2, $a2
	move $a0, $a1
	li $a1, 0
	li $v0, 13
	syscall
	bltz $v0, endArrayFillNeg
	move $a0, $v0
	move $a1, $t0
	move $a2, $t2
	li $v0, 14
	syscall
	endArrayFill:
		move $t3, $v0
		li $v0, 16
		syscall
		move $v0, $t3
		jr $ra
	endArrayFillNeg:
		move $t3, $v0
		li $v0, 16
		syscall
		move $v0, $t3
		li $v0, -1
		jr $ra

find2Byte:
	bltz $a2, notFound
	bltz $a3, notFound
	#Define your code here
	li $t0, 0
	li $t1, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	find2ByteLoop:
		beq $t0, $a3, newRow
		continuefind2ByteLoop:
			beq $t1, $a2, notFound
			lb $t4, 0($a0)
			lb $t5, 1($a0)
			
			move $t6, $a1
			sll $t6, $t6, 24
			srl $t6, $t6, 24
			
			move $t7, $a1
			srl $t7, $t7, 8
			sll $t7, $t7, 24
			srl $t7, $t7, 24
			
			bne $t4, $t6, notYetFound
			bne $t5, $t7, notYetFound
			j found
			notYetFound:
				li $t4, 0
				li $t5, 0
				li $t6, 0
				li $t7, 0
				addi $a0, $a0, 2
				addi $t0, $t0, 1
				j find2ByteLoop
	
	newRow:
		li $t0, 0
		addi $t1, $t1, 1
		j continuefind2ByteLoop
					
	found:
		move $v0, $t1
		move $v1, $t0
		jr $ra
		
	notFound:
		li $v0, -1
		li $v1, -1
		jr $ra
		
		
##############################
# PART 2/3 FUNCTION
##############################



##############################################################


	      #DOES NOT ACCOUNT FOR SAVED MOWER#


##############################################################

setMower:
	la $t4, mowerLocation
	beq $a1, -1, savedLocation
	mowerSet:
	li $t0, 80
	mul $a3, $a1, $t0
	add $a3, $a3, $a2
	li $t0, 2
	mul $a3, $a3, $t0
	add $a0, $a0, $a3
	li $t2, 0x2B
	li $t3, 0x2F
	sb $t2, 0($a0)
	sb $t3, 1($a0)
	jr $ra
	
	savedLocation:
		lw $a1, 0($t4)
		lw $a2, 4($t4)
		j mowerSet

updateMower:
	li $t0, 80
	mul $a3, $a1, $t0
	add $a3, $a3, $a2
	li $t0, 2
	mul $a3, $a3, $t0
	add $a0, $a0, $a3
	lb $t9, 1($a0)
	li $t2, 0x2B
	sb $t2, 0($a0)
	li $t2, 0x2F
	sb $t2, 1($a0)
	jr $ra		
	
#a0 = array
#a1 = row
#a2 = column				
changeBoldBit:

	li $t0, 80
	mul $a3, $a1, $t0
	add $a3, $a3, $a2
	li $t0, 2
	mul $a3, $a3, $t0
	add $a0, $a0, $a3
	bnez $t8, cBB2
	lb $t1, 1($a0)
	ori $t1, $t1, 0x80
	sb $t1, 1($a0)
	li $t1, 0x20
	sb $t1, 0($a0)
	li $t8, 1
	jr $ra
	
	cBB2:
		ori $t9, $t9, 0x80
		sb $t9, 1($a0)
		li $t1, 0x20
		sb $t1, 0($a0)
		jr $ra

#a0 = array
#a1 = row
#a2 = column
#v0 = 1 if collision, 0 if no collision
checkCollision:
	li $t0, 80
	mul $a3, $a1, $t0
	add $a3, $a3, $a2
	li $t0, 2
	mul $a3, $a3, $t0
	add $a0, $a0, $a3
	lb $t0, 0($a0)
	lb $t1, 1($a0)
	beq $t0, 0x52, possibleRock
	beq $t0, 0x20, possibleWaterOrDirt
	beq $t0, 0x6F, possibleFlower
	beq $t0, 0x5E, possibleTree
	notCollision:
	li $v0, 0
	jr $ra
	
	possibleRock:
		bne $t1, 0x7F, notCollision
		li $v0, 1
		jr $ra
	
	possibleWaterOrDirt:
		beq $t1, 0x4F, collision
		beq $t1, 0x3F, collision
		j notCollision
		
	possibleFlower:
		bne $t1, 0xffffffB0, notCollision
		li $v0, 1
		jr $ra
		
	possibleTree:
		bne $t1, 0x2F, notCollision
		li $v0, 1
		jr $ra
		
	collision:
		li $v0, 1
		jr $ra


#$a0 = base address of array
#$a1 = row
#$a2 = column
#$a3 = address of string of characters
playGame:
	
	j continuePlayGame
	checkA2:

	bne $a1, -1, gameEnd
	j continue2
	
	continuePlayGame:
	blt $a1, -1, gameEnd
	blt $a2, -1, gameEnd
	bgt $a1, 24, gameEnd
	bgt $a2, 79, gameEnd
	
	beq $a1, -1, checkA2
	
	continue2:
	
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t9, 0
	li $t8, 0
	
	#call setMower function to set initial position
	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a3, 4($sp)
	sw $ra, 8($sp)
	jal setMower
	lw $a0, 0($sp)
	lw $a3, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	
	loopString:
		li $v0, 32
		move $t7, $a0
		li $a0, 500
		syscall
		move $a0, $t7
		lb $t6, 0($a3)
		beqz $t6, endPlayGame
		move $t4, $a1
		move $t5, $a2
		beq $t6, 0x77, CaseW
		beq $t6, 0x61, CaseA
		beq $t6, 0x73, CaseS
		beq $t6, 0x64, CaseD
		addi $a3, $a3, 1
		j loopString
		
	CaseW:
	
		addi $sp, $sp, -56
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)
		sw $a3, 12($sp)
		sw $ra, 16($sp)
		sw $t0, 20($sp)
		sw $t1, 24($sp)
		sw $t2, 28($sp)
		sw $t3, 32($sp)
		sw $t4, 36($sp)
		sw $t5, 40($sp)
		sw $t6, 44($sp)
		sw $t8, 48($sp)
		sw $t9, 52($sp)
		beq $a1, 0, caseOneW2
		addi $a1, $a1, -1
		returnFromCaseOneW2:
		jal checkCollision
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $a3, 12($sp)
		lw $ra, 16($sp)
		lw $t0, 20($sp)
		lw $t1, 24($sp)
		lw $t2, 28($sp)
		lw $t3, 32($sp)
		lw $t4, 36($sp)
		lw $t5, 40($sp)
		lw $t6, 44($sp)
		lw $t8, 48($sp)
		lw $t9, 52($sp)
		addi $sp, $sp, 56	
		bnez $v0, handleCollision
		
			
			
		addi $sp, $sp, -56
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)
		sw $a3, 12($sp)
		sw $ra, 16($sp)
		sw $t0, 20($sp)
		sw $t1, 24($sp)
		sw $t2, 28($sp)
		sw $t3, 32($sp)
		sw $t4, 36($sp)
		sw $t5, 40($sp)
		sw $t6, 44($sp)
		sw $t8, 48($sp)
		sw $t9, 52($sp)
		jal changeBoldBit
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $a3, 12($sp)
		lw $ra, 16($sp)
		lw $t0, 20($sp)
		lw $t1, 24($sp)
		lw $t2, 28($sp)
		lw $t3, 32($sp)
		lw $t4, 36($sp)
		lw $t5, 40($sp)
		lw $t6, 44($sp)
		lw $t9, 52($sp)
		addi $sp, $sp, 56
		
		beq $a1, 0, caseOneW
		addi $a1, $a1, -1
		returnFromCaseOneW:
		addi $sp, $sp, -56
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)
		sw $a3, 12($sp)
		sw $ra, 16($sp)
		sw $t0, 20($sp)
		sw $t1, 24($sp)
		sw $t2, 28($sp)
		sw $t3, 32($sp)
		sw $t4, 36($sp)
		sw $t5, 40($sp)
		sw $t6, 44($sp)
		sw $t8, 48($sp)
		sw $t9, 52($sp)
		jal updateMower
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $a3, 12($sp)
		lw $ra, 16($sp)
		lw $t0, 20($sp)
		lw $t1, 24($sp)
		lw $t2, 28($sp)
		lw $t3, 32($sp)
		lw $t4, 36($sp)
		lw $t5, 40($sp)
		lw $t6, 44($sp)
		lw $t8, 48($sp)
		addi $sp, $sp, 56
		addi $a3, $a3, 1
		
		
		
		j loopString
		
		
	caseOneW:
		li $a1, 24
		j returnFromCaseOneW
		
	caseOneW2:
		li $a1, 24
		j returnFromCaseOneW2
	
	CaseA:
	
		addi $sp, $sp, -56
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)
		sw $a3, 12($sp)
		sw $ra, 16($sp)
		sw $t0, 20($sp)
		sw $t1, 24($sp)
		sw $t2, 28($sp)
		sw $t3, 32($sp)
		sw $t4, 36($sp)
		sw $t5, 40($sp)
		sw $t6, 44($sp)
		sw $t8, 48($sp)
		sw $t9, 52($sp)
		beq $a2, 0, caseOneA2
		addi $a2, $a2, -1
		returnFromCaseOneA2:
		jal checkCollision
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $a3, 12($sp)
		lw $ra, 16($sp)
		lw $t0, 20($sp)
		lw $t1, 24($sp)
		lw $t2, 28($sp)
		lw $t3, 32($sp)
		lw $t4, 36($sp)
		lw $t5, 40($sp)
		lw $t6, 44($sp)
		lw $t8, 48($sp)
		lw $t9, 52($sp)
		addi $sp, $sp, 56	
		bnez $v0, handleCollision
		
		
		addi $sp, $sp, -56
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)
		sw $a3, 12($sp)
		sw $ra, 16($sp)
		sw $t0, 20($sp)
		sw $t1, 24($sp)
		sw $t2, 28($sp)
		sw $t3, 32($sp)
		sw $t4, 36($sp)
		sw $t5, 40($sp)
		sw $t6, 44($sp)
		sw $t8, 48($sp)
		sw $t9, 52($sp)
		jal changeBoldBit
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $a3, 12($sp)
		lw $ra, 16($sp)
		lw $t0, 20($sp)
		lw $t1, 24($sp)
		lw $t2, 28($sp)
		lw $t3, 32($sp)
		lw $t4, 36($sp)
		lw $t5, 40($sp)
		lw $t6, 44($sp)
		lw $t9, 52($sp)
		addi $sp, $sp, 56
		
		beq $a2, 0, caseOneA
		addi $a2, $a2, -1
		returnFromCaseOneA:
		addi $sp, $sp, -56
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)
		sw $a3, 12($sp)
		sw $ra, 16($sp)
		sw $t0, 20($sp)
		sw $t1, 24($sp)
		sw $t2, 28($sp)
		sw $t3, 32($sp)
		sw $t4, 36($sp)
		sw $t5, 40($sp)
		sw $t6, 44($sp)
		sw $t8, 48($sp)
		sw $t9, 52($sp)
		jal updateMower
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $a3, 12($sp)
		lw $ra, 16($sp)
		lw $t0, 20($sp)
		lw $t1, 24($sp)
		lw $t2, 28($sp)
		lw $t3, 32($sp)
		lw $t4, 36($sp)
		lw $t5, 40($sp)
		lw $t6, 44($sp)
		lw $t8, 48($sp)
		addi $sp, $sp, 56
		addi $a3, $a3, 1
		
		
		
		j loopString
		
		
	caseOneA:
		li $a2, 79
		j returnFromCaseOneA
		
	caseOneA2:
		li $a2, 79
		j returnFromCaseOneA2
	
	CaseS:
	
		addi $sp, $sp, -56
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)
		sw $a3, 12($sp)
		sw $ra, 16($sp)
		sw $t0, 20($sp)
		sw $t1, 24($sp)
		sw $t2, 28($sp)
		sw $t3, 32($sp)
		sw $t4, 36($sp)
		sw $t5, 40($sp)
		sw $t6, 44($sp)
		sw $t8, 48($sp)
		sw $t9, 52($sp)
		beq $a1, 24, caseOneS2
		addi $a1, $a1, 1
		returnFromCaseOneS2:
		jal checkCollision
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $a3, 12($sp)
		lw $ra, 16($sp)
		lw $t0, 20($sp)
		lw $t1, 24($sp)
		lw $t2, 28($sp)
		lw $t3, 32($sp)
		lw $t4, 36($sp)
		lw $t5, 40($sp)
		lw $t6, 44($sp)
		lw $t8, 48($sp)
		lw $t9, 52($sp)
		addi $sp, $sp, 56	
		bnez $v0, handleCollision
	
		addi $sp, $sp, -56
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)
		sw $a3, 12($sp)
		sw $ra, 16($sp)
		sw $t0, 20($sp)
		sw $t1, 24($sp)
		sw $t2, 28($sp)
		sw $t3, 32($sp)
		sw $t4, 36($sp)
		sw $t5, 40($sp)
		sw $t6, 44($sp)
		sw $t8, 48($sp)
		sw $t9, 52($sp)
		jal changeBoldBit
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $a3, 12($sp)
		lw $ra, 16($sp)
		lw $t0, 20($sp)
		lw $t1, 24($sp)
		lw $t2, 28($sp)
		lw $t3, 32($sp)
		lw $t4, 36($sp)
		lw $t5, 40($sp)
		lw $t6, 44($sp)
		lw $t9, 52($sp)
		addi $sp, $sp, 56
		
		beq $a1, 24, caseOneS
		addi $a1, $a1, 1
		returnFromCaseOneS:
		addi $sp, $sp, -56
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)
		sw $a3, 12($sp)
		sw $ra, 16($sp)
		sw $t0, 20($sp)
		sw $t1, 24($sp)
		sw $t2, 28($sp)
		sw $t3, 32($sp)
		sw $t4, 36($sp)
		sw $t5, 40($sp)
		sw $t6, 44($sp)
		sw $t8, 48($sp)
		sw $t9, 52($sp)
		jal updateMower
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $a3, 12($sp)
		lw $ra, 16($sp)
		lw $t0, 20($sp)
		lw $t1, 24($sp)
		lw $t2, 28($sp)
		lw $t3, 32($sp)
		lw $t4, 36($sp)
		lw $t5, 40($sp)
		lw $t6, 44($sp)
		lw $t8, 48($sp)
		addi $sp, $sp, 56
		addi $a3, $a3, 1
		
		
		
		j loopString
		
		
	caseOneS:
		li $a1, 0
		j returnFromCaseOneS
	
	caseOneS2:
		li $a1, 0
		j returnFromCaseOneS2
	
	CaseD:
	
	
		addi $sp, $sp, -56
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)
		sw $a3, 12($sp)
		sw $ra, 16($sp)
		sw $t0, 20($sp)
		sw $t1, 24($sp)
		sw $t2, 28($sp)
		sw $t3, 32($sp)
		sw $t4, 36($sp)
		sw $t5, 40($sp)
		sw $t6, 44($sp)
		sw $t8, 48($sp)
		sw $t9, 52($sp)
		beq $a2, 79, caseOneD2
		addi $a2, $a2, 1
		returnFromCaseOneD2:
		jal checkCollision
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $a3, 12($sp)
		lw $ra, 16($sp)
		lw $t0, 20($sp)
		lw $t1, 24($sp)
		lw $t2, 28($sp)
		lw $t3, 32($sp)
		lw $t4, 36($sp)
		lw $t5, 40($sp)
		lw $t6, 44($sp)
		lw $t8, 48($sp)
		lw $t9, 52($sp)
		addi $sp, $sp, 56	
		bnez $v0, handleCollision	
	
		addi $sp, $sp, -56
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)
		sw $a3, 12($sp)
		sw $ra, 16($sp)
		sw $t0, 20($sp)
		sw $t1, 24($sp)
		sw $t2, 28($sp)
		sw $t3, 32($sp)
		sw $t4, 36($sp)
		sw $t5, 40($sp)
		sw $t6, 44($sp)
		sw $t8, 48($sp)
		sw $t9, 52($sp)
		jal changeBoldBit
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $a3, 12($sp)
		lw $ra, 16($sp)
		lw $t0, 20($sp)
		lw $t1, 24($sp)
		lw $t2, 28($sp)
		lw $t3, 32($sp)
		lw $t4, 36($sp)
		lw $t5, 40($sp)
		lw $t6, 44($sp)
		lw $t9, 52($sp)
		addi $sp, $sp, 56
		
		beq $a2, 79, caseOneD
		addi $a2, $a2, 1
		returnFromCaseOneD:
		addi $sp, $sp, -56
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)
		sw $a3, 12($sp)
		sw $ra, 16($sp)
		sw $t0, 20($sp)
		sw $t1, 24($sp)
		sw $t2, 28($sp)
		sw $t3, 32($sp)
		sw $t4, 36($sp)
		sw $t5, 40($sp)
		sw $t6, 44($sp)
		sw $t8, 48($sp)
		sw $t9, 52($sp)
		jal updateMower
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		lw $a3, 12($sp)
		lw $ra, 16($sp)
		lw $t0, 20($sp)
		lw $t1, 24($sp)
		lw $t2, 28($sp)
		lw $t3, 32($sp)
		lw $t4, 36($sp)
		lw $t5, 40($sp)
		lw $t6, 44($sp)
		lw $t8, 48($sp)
		addi $sp, $sp, 56
		addi $a3, $a3, 1
		
		
		
		j loopString
		
		
	caseOneD:
		li $a2, 0
		j returnFromCaseOneD
		
	caseOneD2:
		li $a2, 0
		j returnFromCaseOneD2
	
	handleCollision:
		addi $a3, $a3, 1
		j loopString
	
	
	endPlayGame:
	
	la $t4, mowerLocation
	sw $a1, 0($t4)
	sw $a2, 4($t4)
	
	gameEnd:
	#Define your code here
	jr $ra
	


.data
	#Define your memory here 
	
	mowerLocation: .word 24, 79
	