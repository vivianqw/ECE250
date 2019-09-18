.text

main: 

	li $v0, 4
	la $a0, prompt
	syscall

	li $v0, 5
	syscall
	move $a0, $v0

	jal loop
	


	move $t4, $v0
	li $v0, 1
	move $a0, $t4
	syscall

	li $v0, 10
	syscall




loop:

	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $a0, 4($sp)


	beq $a0, 0, baseZero
	beq $a0, 1, baseOne

	addi $a0, $a0, -1
	jal loop
	move $s0, $v0
	mul $s0, $s0, 3
	sw $s0, 8($sp)
	#s0 stores 3f(N-1)

	lw $a0, 4($sp)
	addi $a0, $a0, -2
	jal loop
	move $s1, $v0
	mul $s1, $s1, 2#s1 stores 2f(N-2)


	lw $s0, 8($sp)
	add $v0, $s0, $s1
	addi $v0, $v0, 1
	lw $ra, 0($sp)
	addi $sp, $sp, 16
	jr $ra

	
base: 
	bgt $a0, 1, loop
	beq $a0, 1, baseOne
	beq $a0, 0, baseZero

baseOne: 
	li $v0, 5
	j exit

baseZero:
	li $v0, 2
	j exit

exit: 
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $s0, 8($sp)
	addi $sp, $sp, 16
	jr $ra



.data
prompt : .ascii "Please input a number:"
