.data
	display: .space 1024   #Reserva espacio para el display (256 palabras)
	head: .word 0 #Cabeza de la serpiente
	tail: .word 0 #Cola de la serpiente
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
	li $s5, 1 #Direccion inicial (abajo)
	PlayLoop:
		li $v0, 32
		la $a0, 150 #Delay de 200ms
		syscall
		beq $s5, 1, Down
		beq $s5, 2, Up
		beq $s5, 3, Left
		beq $s5, 4, Right
		beq $s5, 5, StopPlaying
		j PlayLoop
StopPlaying:
	jr $t9
GameOver: #Si se da la condicion, actualiza valores para que acabe el juego
	li $s5, 5
	li $s1, 1
	li $s2, 1
	j PlayLoop

	
Down: #Mueve la serpiente automaticamente hacia abajo
	addi $s1, $s1, 1
	jal CalcPos
	bgt $s1, 15, GameOver #Verifica si toca un borde
	sw $t6, head #Actualiza la cabeza
	jal SetPixel
	jal UpdateTailAuto
	j PlayLoop

Up: #Mueve la serpiente automaticamente hacia arriba
	addi $s1, $s1, -1
	jal CalcPos
	blt $s1, 0, GameOver #Verifica si toca un borde
	sw $t6, head #Actualiza la cabeza
	jal SetPixel
	jal UpdateTailAuto
	j PlayLoop
Right: #Mueve la serpiente automaticamente hacia la derecha
	addi $s2, $s2, 1
	jal CalcPos
	bgt $s2, 15, GameOver #Verifica si toca un borde
	sw $t6, head #Actualiza la cabeza
	jal SetPixel
	jal UpdateTailAuto
	j PlayLoop
Left: #Mueve la serpiente automaticamente hacia la izquierda
	addi $s2, $s2, -1
	jal CalcPos
	blt $s2, 0, GameOver #Verifica si toca un borde
	sw $t6, head #Actualiza la cabeza
	jal SetPixel
	jal UpdateTailAuto
	j PlayLoop

UpdateTailAuto: #Actualizar la cola con el movimiento automatico de la serpiente
	lw $t8, tail
	li $t7, 0x008080 #Color de fondo (turquesa)
	sw $t7, ($t8)
	sw $t6, tail
	li $t7, 0x00FF00 #Color de la serpiente (verde lima)
	jr $ra
	
SetPlayer: #Colocar al jugador al inicio del juego
	move $t9, $ra
	li $s1, 1
	li $s2, 7
	jal CalcPos
	sw $t6, head #Inicializa la posicion de la cabeza
	sw $t6, tail #Inicializa la posicion de la cola
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

