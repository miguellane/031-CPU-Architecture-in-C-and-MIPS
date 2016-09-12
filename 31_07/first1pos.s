main:
	lui	$a0,0x8000
	jal	first1pos
	jal	printv0
	lui	$a0,0x0001
	jal	first1pos
	jal	printv0
	li	$a0,1
	jal	first1pos
	jal	printv0
	add	$a0,$0,$0
	jal	first1pos
	jal	printv0
	li	$v0,10
	syscall

first1pos:
	addi	$sp,$sp,-4
	sw	$ra,0($sp)
	addi	$t0,$0,0x80000000
	blt	$a0,$t0, negative
	jal	shift
	
	j	end
negative:
	andi	$a0,$a0,0x7FFFFFFF
	jal	shift
	j	end
#
shift:
	beqz	$ao,return
return:
	jr	$ra
#	
end:
	lw	$ra,0($sp)
	addi	$sp,$sp,4
	jr	$ra

printv0:
	addi	$sp,$sp,-4
	sw	$ra,0($sp)
	add	$a0,$v0,$0
	li	$v0,1
	syscall
	li	$v0,11
	li	$a0,'\n'
	syscall
	lw	$ra,0($sp)
	addi	$sp,$sp,4
	jr	$ra
