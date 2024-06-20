.data
	display: .space 1024
.text
	.globl main
main:
	li $t1 0 #contador
	jal SetBG
	li $v0, 10
	syscall
SetBG:
	beq $t1, 1024, EndLoop
	li $t0 0xFF8040
	sw $t0, display($t1)
	addi $t1, $t1, 4
	li $t0 0x804000
	sw $t0, display($t1)
	addi $t1, $t1, 4
	j SetBG
EndLoop:
	jr $ra
	