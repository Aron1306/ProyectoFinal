.data
	display: .space 1024   # Reserva espacio para el display (256 palabras)
.text
	.globl main
main:
	li $t1, 0 #Inicializa el contador 
     li $s3, 0 #Cantidad de frutas
     jal SetBG #Crea el fondo del juego 
     jal SetFruit #colocar frutas
 	jal SetPlayer #Se coloca al jugador
 	jal PlaySnake #Jugar al juego
     li $v0, 10       
     syscall
PlaySnake:
	move $t9, $ra
	li $s5, 5 #Direccion inicial (abajo)
	PlayLoop:
		li $v0, 32
		la $a0, 700
		syscall
		beq $s5, 1, Down
		beq $s5, 2, Up
		beq $s5, 3, Left
		beq $s5, 4, Right
		beq $s5, 5, StopPlaying
		j PlayLoop
StopPlaying:
	jr $t9

Down:
	addi $s1, $s1, 1
	jal CalcPos
	jal SetPixel
	j PlayLoop

Up:
	addi $s1, $s1, -1
	jal CalcPos
	jal SetPixel
	j PlayLoop
Right: 
	addi $s2, $s2, 1
	jal CalcPos
	jal SetPixel
	j PlayLoop
Left: 
	addi $s2, $s2, -1
	jal CalcPos
	jal SetPixel
	j PlayLoop
	
	

	

SetPlayer: #Colocar al jugador en el juego
	move $t9, $ra
	li $s1, 1
	li $s2, 7
	jal CalcPos
	move $s7, $t6
	li $t7, 0x00FF00
	jal SetPixel
	jr $t9
SetFruit: #Coloca las frutas en el bitmap
	li $t7 0xFF0000
	move $t9, $ra #Mantener la direccion de la llamada
	FruitLoop:
		beq $s3, 3, EndSetFruit
		#Se calcula y
		li $a1, 16 
		li $v0, 42
		syscall
		move $s1, $a0
		#Se calcula x
		li $a1, 16 
		li $v0, 42
		syscall
		move $s2, $a0
		jal CalcPos
		jal SetPixel
		addi $s3, $s3, 1
		j FruitLoop
EndSetFruit:
	jr $t9
SetPixel: #Aplica un color a un pixel especifico (Recibe posicion, color)
	sw $t7, ($t6)
	jr $ra
	
CalcPos: #Calcular posicion en el bitmap (Recibe x, y)
	li $t4, 16        
	mul $t5, $t4, $s1  
	add $t5, $t5, $s2  
     sll $t5, $t5, 2   
     la $t6, display    
     add $t6, $t6, $t5  #t6 es la posicion en el bitmap    
     jr $ra
     
SetBG: #Crea el background del tablero
	beq $t1, 1024, EndLoop
	li $t0 0x008080 #Aplica el color turquesa
	sw $t0, display($t1)
	addi $t1, $t1, 4
	j SetBG
EndLoop:
	li $t1 0 #Reinicia el registro del contador
	jr $ra

