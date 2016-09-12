
	.text

main:
	li $a0, 0
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, 1
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, 196
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, -1
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, -452
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, 2
	jal mystery
	move $a0, $v0
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall

	li $a0, 3
	jal mystery
	move $a0, $v0
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall

	li 	$v0, 10		# terminate program
	syscall

putDec:	sub	$sp, $sp, 8
 	sw	$ra, 4($sp)
 	sw	$a0, 0($sp)
	andi	$t0, $a0, 0x80000000
	beq	$t0, $0, posNum
	li	$a0, 0x2D
	li	$v0, 11
	syscall
	lw	$a0, 0($sp)
	xori	$a0, $a0, 0xFFFFFFFF
	addi	$a0, $a0, 1
posNum:

	li	$v0, 11
	syscall
	lw	$ra, 4($sp)
 	add	$sp, $sp, 4
	jr	$ra		# returnv

mystery: bne $0, $a0, recur 	# 
 	li $v0, 0 		#
 	jr $ra 			#
 recur: sub $sp, $sp, 8 	#
 	sw $ra, 4($sp) 	#
 	sub $a0, $a0, 1 	#
 	jal mystery 		#
 	sw $v0, 0($sp) 	#
 	jal mystery 		#
 	lw $t0, 0($sp) 	#
 	addu $v0, $v0, $t0 	#
 	addu $v0, $v0, 1 	#
 	add $a0, $a0, 1 	#

 	jr $ra 			#
