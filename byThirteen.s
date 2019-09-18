.text

main:
	li $v0, 4
	la $a0, prompt
	syscall

	li $v0, 5
	syscall

	move $a1, $v0
	li $a2, 0


loop: 
	beq $a1, $0, done
	add $a2, $a2, 13
	sub $a1, $a1, 1

	li $v0, 1
	move $a0, $a2
	syscall

	li $v0, 4
	la $a0, nln
	syscall
	j loop


done: 
	li $v0, 10
	syscall


.data
prompt : .asciiz "Please input a number:"
nln : .asciiz"\n"
