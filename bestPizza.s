

.text

main: 
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $s0, 4($sp) #name of pizza
	sw $s1, 8($sp) #price of pizza
	sw $s2, 12($sp) #currentPizza
	sw $s3, 16($sp) 
	sw $s4, 20($sp) #start of pizzaList

	la $s3, Done
	li $s4, 0

loop:

	jal input
	move $s0, $v0

	jal inputPrice
	move $s1, $v0

	li $v0, 9
	li $a0, 76
	syscall

	addi $s2, $s2, -76
	move $s2, $v0
	move $a0, $s0
	move $a1, $s2
	jal write

	sw $0, 64($s2)
	sw $s1, 68($s2)
	sw $0, 72($s2)

	beq $s4, 0, firstPizza

	move $a0, $s2 #current pizza
	move $a1, $s4 #current pizza
	jal sort

	move $s4, $v0

	j loop

firstPizza:	
	move $s4, $s2
	j loop


printout: 
	beq $s4, 0, finallyEnding

	li $v0, 4
	move $a0, $s4
	syscall

	li $v0, 4
	la $a0, space
	syscall

	li $v0, 2
	l.s $f12, 68($s4)
	syscall

	li $v0, 4
	la $a0, nln
	syscall

	lw $s4, 72($s4)
	j printout

finallyEnding:

	lw $ra, 0($sp)
	lw $s0, 4($sp) 
	lw $s1, 8($sp) 
	lw $s1, 12($sp) 
	lw $s2, 16($sp) 
	lw $s4, 20($sp)
	addi $sp, $sp, 24

	li $v0, 10
	syscall




write: 
	addi $sp, $sp, -4 
	sw $ra, 0($sp)	

writeLoop: 
	la $t6, nln
	lb $t7, ($t6) 
	lb $t1, ($a0)
	beq $t1, $t7, stopWrite
	sb $t1, ($a1)
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	j writeLoop

stopWrite: 
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


sort: 
	addi $sp, $sp, -4 #a0 is current pizza, a1 is head of pizzaList
	sw $ra, 0($sp)

	move $t0, $a0 #t0 current pizza
	move $t1, $a1 #t1 head of pizzaList
	move $t2, $t1 #t2 tempPizza
	move $t3, $t1 #t3 oldPizza

	move $a0, $t0
	move $a1, $t1
	jal comparePizza

	move $t4, $v0
	bne $t4,0, moveLargePizza
	lw $t4, 72($t3)
	beq $t4, 0, moveSmallPizza

sortWrite: 
	lw $t4, 72($t1)
	beq $t4, 0, storeNextPizza 
	move $a0, $t0
	move $a1, $t1
	jal comparePizza

	move $t4, $v0
	bne $t4, 0, storePrevPizza
	move $t3, $t1
	lw $t1, 72($t1)
	j sortWrite

storePrevPizza: 
	sw $t1, 72($t0)
	sw $t0, 72($t3)

	move $v0, $t2
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

moveLargePizza: 
	sw $t1, 72($t0) #put current pizza after pizzaList
	move $t2, $t0
	move $v0, $t2

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

storeNextPizza: 
	move $a0, $t0 #current
	move $a1, $t1 #pizzaList
	jal comparePizza
	beq $v0, 0, moveSmallPizza

	sw $t1, 72($t0)
	sw $t0, 72($t3)

	move $v0, $t2
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

moveSmallPizza: 
	sw $t0, 72($t1) #put pizzaList before current pizza
	move $v0, $t2

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

comparePizza: #a0 is current pizza, a1 is head of pizzaList
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)

	move $t2, $a0
	move $t3, $a1

	lw $t0, 68($a0) #current price
	lw $t1, 68($a1) #list price
	bgt $t0, $t1, currentLarge
	bgt $t1, $t0, currentSmall

	move $a0, $t2
	move $a1, $t3
	jal strComp
	ble $v0, 0, currentLarge
	j currentSmall

currentLarge: 
	li $v0, 1
	lw $ra, 0($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	addi $sp, $sp, 24
	jr $ra

currentSmall: 
	li $v0, 0
	lw $ra, 0($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	addi $sp, $sp, 24
	jr $ra




input:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	li $v0, 4			#asking for name and saving 
	la $a0, namePrompt
	syscall

	li $v0, 8
	la $a0, name
	li $a1, 64
	move $t5, $a0
	syscall

	move $a0, $t5

	la $a1, Done
	jal strComp
	beq $v0, 0, printout

	move $v0, $t5
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra



inputPrice: 
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	li $v0, 4
	la $a0, diaPrompt
	syscall

	li $v0, 6 
	syscall
	mov.s $f4, $f0 #diameter = f4

	li $v0, 4
	la $a0, pricePrompt
	syscall

	li $v0, 6
	syscall
	mov.s $f2, $f0 #price = f2

	l.s $f10, four #4 is in f10
	l.s $f12, zero #0 is in f12
	l.s $f14, PI   #pi is in f14

	c.eq.s $f2, $f12
	bc1t zeroPrice

	mul.s $f6, $f4, $f4 #d^2
	div.s $f6, $f6, $f10 #d^2/4
	mul.s $f6, $f6, $f14 #pi*d^2/4
	div.s $f6, $f6, $f2

	mfc1 $v0, $f6
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


zeroPrice: 
	li $v0, 0
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


strComp: 
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	move $t3, $a0
	move $t4, $a1

compMain: 
	lb $t1, ($t3)
	lb $t2, ($t4)
	beq $t1, $t2, sameChar
	blt $t1, $t2, twoGreat
	bgt $t1, $t2, oneGreat

sameChar:
	beq $t1, 0, allSame
	addi $t3, $t3, 1
	addi $t4, $t4, 1
	j compMain

allSame: 
	li $v0, 0
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

twoGreat: 
	li $v0, -1
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

oneGreat: 
	li $v0, 1
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


.data
nln: .asciiz "\n"
namePrompt: 
	.asciiz "Pizza name:"
diaPrompt: 
	.asciiz "Pizza diameter:"
pricePrompt: 
	.asciiz "Pizza price:"
Done: 
	.asciiz "DONE\n"
name: .space 64
space: .asciiz" "
PI: .float 3.1415927
four: .float 4.0
zero: .float 0.0
