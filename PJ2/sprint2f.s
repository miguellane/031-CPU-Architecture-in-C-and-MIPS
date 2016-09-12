#sprintf!
#$a0 has the pointer to the buffer to be printed to
#$a1 has the pointer to the format string
#$a2 and $a3 have (possibly) the first two substitutions for the format string
#the rest are on the stack
#return the number of characters (ommitting the trailing '\0') put in the buffer
	.text

        .data
buffer:	.space	20000			# 2000 bytes of empty space 
format:	.asciiz "%8s, unsigned dec: %u hex: 0x%x, oct: 0%o, dec: %d"
str:	.asciiz "thirty"		# null-terminated string at
chrs:	.asciiz " characters:\n"	# null-terminated string at 
	.text
	.globl sprintf
main:	addi	$sp,$sp,-32	# reserve stack space
	la	$a0,buffer	# arg 0 <- buffer
	la	$a1,format	# arg 1 <- format
	la	$a2,str		# arg 2 <- str
	addi	$a3,$0,255	# arg 3 <- 255
	sw	$a3,16($sp)	# arg 4 <- 255
	addi	$t0,$0,250
	sw	$t0,20($sp)	# arg 5 <- 250
        addi    $t0,$0,-255
        sw      $t0,24($sp)     # arg 6 <- -255
	sw	$ra,28($sp)	# save return address
	jal	sprintf		# $v0 = sprintf(...)
	add	$a0,$v0,$0	# $a0 <- $v0
	jal	putint		# putint($a0)
 	li 	$v0, 4	
	la     	$a0, chrs
	syscall
	li	$v0, 4
	la	$a0, buffer
	syscall
	addi	$sp,$sp,32	# restore stack
	li 	$v0, 10		# terminate program
	syscall

putint:	addi	$sp,$sp,-8	# get 2 words of stack
	sw	$ra,0($sp)	# store return address
	
	remu	$t0,$a0,10	# $t0 <- $a0 % 10
	addi	$t0,$t0,'0'	# $t0 += '0' ($t0 is now a digit character)
	divu	$a0,$a0,10	# $a0 /= 10
	beqz	$a0,onedig	# if( $a0 != 0 ) { 
	sw	$t0,4($sp)	#   save $t0 on our stack
	jal	putint		#   putint() (putint will deliberately use and modify $a0)
	lw	$t0,4($sp)	#   restore $t0
	                        # } 
onedig:	move	$a0, $t0
	li 	$v0, 11
	syscall			# putc #$t0
	#putc	$t0		# output the digit character $t0
	lw	$ra,0($sp)	# restore return address
	addi	$sp,$sp, 8	# restore stack
	jr	$ra		# return




########################################################################################################################################################################################################
#t0 char transaction and post % arg;  t1 counter
sprintf:addi	$sp, $sp, 4
	bne	$a3, $0, arg2	
	lw	$a2, 0($sp)
	lw	$a3, 0($sp)
	addi	$sp, $sp, 8
arg2:	addi	$sp, $sp, 4
	bne	$a3, $0, arg3
	lw	$a3, 0($sp)
arg3:	addi	$sp, $sp, 4
start:	addi	$s0, $ra, 0
	lb	$t0, 0($a1)
	beq	$t0, '\0', done	#if *a1 = \0
	beq	$t0, '%', fun
	j	norm
fun:	addi	$a1, $a1, 1
	lb	$t0, 0($a1)
	beq	$t0, 'u', ufuna
	beq	$t0, 'x', xfuna	
	beq	$t0, 'o', ofuna
	
	li	$t0, 0
	li	$t1, 0
check:	add	$t2, $a1, $t0
	lb	$t1, 0($t2)
	beq	$t1, 's', sfuna
	beq	$t1, 'd', dfuna
	addi	$t0, $t0, 1	#t0 digits between % and s
	j	check	
########################################################################################################################################################################################################	
ufuna:	li	$t1, 0
ufun:	beq	$a2, $0, uflipa
	addi	$sp, $sp, -1
	addi	$t1, $t1, 1
	li	$t0, 10
	div	$a2, $t0
	mfhi	$t0
	addi	$t0, $t0, '0'
	sb	$t0, 0($sp)
	mflo	$a2
	j	ufun
uflipa:	addi	$t2, $t1, 0
uflip:	beq	$t2, 0, udone
	lb	$t0, 0($sp)
	sb	$t0, 0($a0)
	addi	$sp, $sp, 1
	addi	$a0, $a0, 1
	addi	$t2, $t2, -1
	j	uflip
udone:	addi	$a1, $a1, 1
	j	nextf
########################################################################################################################################################################################################	
xfuna:	li	$t1, 0	
xfun:	beq	$a2, $0, xflipa
	addi	$sp, $sp, -1
	addi	$t1, $t1, 1
	li	$t0, 16
	div	$a2, $t0
	mfhi	$t0
	bge	$t0, 10, xlet
	addi	$t0, $t0, '0'
	j	letout
xlet:
	addi	$t0, $t0, 55
letout:	
	sb	$t0, 0($sp)
	mflo	$a2
	j	xfun
xflipa:	addi	$t2, $t1, 0
xflip:	beq	$t2, 0, xdone
	lb	$t0, 0($sp)
	sb	$t0, 0($a0)
	addi	$sp, $sp, 1
	addi	$a0, $a0, 1
	addi	$t2, $t2, -1
	j	xflip
xdone:	addi	$a1, $a1, 1
	j	nextf
########################################################################################################################################################################################################
ofuna:	li	$t1, 0
ofun:	beq	$a2, $0, oflipa
	addi	$sp, $sp, -1
	addi	$t1, $t1, 1
	li	$t0, 8
	div	$a2, $t0
	mfhi	$t0
	addi	$t0, $t0, '0'
	sb	$t0, 0($sp)
	mflo	$a2
	j	ofun
oflipa:	addi	$t2, $t1, 0
oflip:	beq	$t2, 0, odone
	lb	$t0, 0($sp)
	sb	$t0, 0($a0)
	addi	$sp, $sp, 1
	addi	$a0, $a0, 1
	addi	$t2, $t2, -1
	j	oflip
odone:	addi	$a1, $a1, 1
	j	nextf
########################################################################################################################################################################################################
sfuna:	lb	$t1, 0($a1)	#t1 %_	 min val
	addi	$t1, $t1, -48
	lb	$t3, 2($a1)	#t3 %_._ max val
	addi	$t3, $t3, -48
	li	$t5, 0		#swap
	li	$t6, 0		#size of a3
	addi	$t4, $a2, 0	#t4 count up
sizea3:	lb	$t5, 0($t4)
	beq	$t5, 0, sizea3o
	addi	$t6, $t6, 1
	addi	$t4, $t4, 1
	j	sizea3
sizea3o:li	$t4, 0
	beq	$t0, 0, all
	beq	$t0, 1, min
	beq	$t0, 2, max
	beq	$t0, 3, sin
all:	li	$t1, -1
	li	$t3, -1
	j	sin
min:	li	$t3, -1
	j	sin
max:	li	$t1, -1
	lb	$t3, 1($a1)
	addi	$t3, $t3, -48
	j	sin
	
sin:	add	$t5, $t1, $t3
	sub	$t6, $t5, $t6
	li	$t5, ' '
smin:
	blez	$t6, smid
	sb	$t5, 0($a0)
	addi	$a0, $a0, 1
	addi	$t6, $t6, -1
	j	smin	
smid:	beq	$t4, $t3, sdone
	lb	$t5, 0($a2)	#foreach(a2) until \0
	addi	$a2, $a2, 1
	beq	$t5, 0, sdone	#til null
	add	$t4, $t4, 1	#count up
	sb	$t5, 0($a0)
	addi	$a0, $a0, 1
	j	smid

sdone:	add	$a1, $a1, $t0
	add	$a1, $a1, 1
	j	nextf
########################################################################################################################################################################################################
dfuna:	li	$t2, 0
	li	$t3, 0
	addi	$t4, $a2, 0	
dsize:	div	$t4, $t4, 10
	beq	$t4, 0, dfunaa
	addi	$t3, $t3, 1
	j	dsize
dfunaa:	lb	$t0, 0($a1)
	beq	$t0, 'd', dset
	beq	$t0, '+', dpos
	beq	$t0, '.', dmax
	addi	$t1, $t0, 0	#t1 min
	addi	$t1, $t1, -48
	addi	$a1, $a1, 1
	j	dfunaa
dmax:	lb	$t2, 4($a1)	#t2 max
	addi	$a1, $a1, 8
	addi	$t2, $t2, -48
	j	dfunaa
dpos:	blez	$a2, dfunaa
	addi	$t3, $t3, 1	#t3 count for characters
	li	$t0, '+'
	sb	$t0, 0($a0)
	addi	$a0, $a0, 1
	addi	$a1, $a1, 1
	j	dfunaa

dset:	beq	$t0, '-', left
	
right:	

left:	bgtz	$a2, dnonne
	
dnonne:		
	
	
	
dset:

	j	nextf
########################################################################################################################################################################################################
norm:	sb	$t0, 0($a0)
	addi	$a0, $a0, 1
	addi	$a1, $a1, 1
	j	start
nextf:	addi	$a2, $a3, 0
	lw	$a3, 4($sp)
	addi	$sp, $sp, 4
	j	start
done:	sb	$t0, 0($a0)	# *a1 = \0
	addi	$ra, $s0, 0
	jr	$ra		#this sprintf implementation rocks!
########################################################################################################################################################################################################







