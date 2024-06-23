.data
display:  .space 4096 #Reserva espacio para el display 
tail:     .word 0 #Cola de la serpiente
HeadX:	.word 0 #Coordenada x de la cabeza
HeadY: 	.word 0 #Coordenada y de la cabeza
FruitX:	.word 0 #Coordenada x de la fruta
FruitY:	.word 0 #Coordenada y de la fruta	
Score:	.asciiz "El juego ha acabado\nPuntuacion final: "
.text
	.globl main
main:
	li   $t1, 0 #Inicializa un contador
	li	$s4, 0 #Puntos
	li	$t3, 0 #Cantidad de frutas
	li	$s3, 150 #Delay 
	jal  SetBG #Crea el fondo del juego 
	jal  SetPlayer #Se coloca al jugador
	jal  PlaySnake #Jugar al juego
	jal	DisplayScore #Muestra la puntuacion
	li   $v0, 10       
	syscall
DisplayScore:
	li	$v0, 4
	la	$a0, Score
	syscall
	
	li	$v0, 1
	move	$a0, $s4
	syscall 
    
CheckFruitCollision:
	lw   $t0, HeadX
	lw   $t1, FruitX
	beq  $t0, $t1, SameX
	jr 	$ra
SameX:
	lw	$t0, HeadY
	lw	$t1, FruitY
	beq	$t0, $t1, SameBoth
	jr	$ra
SameBoth:
	li	$t3, 0
	addi	$s4, $s4, 1
	addi	$s3, $s3, -5
	jr 	$ra
 

PlaySnake:
	move	$t9, $ra
	li	$s5, 4 #Direccion inicial (derecha)
    
PlayLoop:
	jal	CheckFruitCollision
	bne  $t3, 1,  SetFruit
	lw   $t2, 0xffff0004
	li   $v0, 32
	move	$a0, $s3 #Delay de 150ms
	syscall
    
	beq  $s5, 5, StopPlaying	
	beq  $t2, 100, InputRight
	beq  $t2, 97, InputLeft
	beq  $t2, 119, InputUp
	beq  $t2, 115, InputDown
    
InnerLoop:
	beq  $s5, 1, Down
	beq  $s5, 2, Up
	beq  $s5, 3, Left
	beq  $s5, 4, Right
	j    PlayLoop
	
StopPlaying:
	jr	$t9
	
GameOver: #Si se da la condicion, actualiza valores para que acabe el juego
	li	$s5, 5
	li   $s1, 1
	li   $s2, 1
	j    PlayLoop
	
InputRight:
	beq  $s5, 3 InnerLoop #Ignora el input si se quiere ir en direccion contraria
	li   $s5, 4
	j    InnerLoop
	
InputLeft:
	beq  $s5, 4 InnerLoop #Ignora el input si se quiere ir en direccion contraria
	li   $s5, 3
	j    InnerLoop
    
InputUp:
	beq  $s5, 1 InnerLoop #Ignora el input si se quiere ir en direccion contraria
	li   $s5, 2
	j    InnerLoop
InputDown:
	beq  $s5, 2 InnerLoop #Ignora el input si se quiere ir en direccion contraria
	li   $s5, 1
	j    InnerLoop

Down: #Mueve la serpiente automaticamente hacia abajo
	addi $s1, $s1, 1
	sw   $s1, HeadY
	jal  CalcPos
	bgt  $s1, 31, GameOver #Verifica si toca un borde (cambio de 15 a 31)
	jal  SetPixel
	jal  UpdateTailAuto
	j    PlayLoop

Up: #Mueve la serpiente automaticamente hacia arriba
	addi	$s1, $s1, -1
	sw   $s1, HeadY
	jal  CalcPos
	blt  $s1, 0, GameOver #Verifica si toca un borde
	jal  SetPixel
	jal  UpdateTailAuto
	j    PlayLoop
    
Right: #Mueve la serpiente automaticamente hacia la derecha
	addi $s2, $s2, 1
	sw   $s2, HeadX
	jal  CalcPos
	bgt  $s2, 31, GameOver #Verifica si toca un borde 
	jal  SetPixel
	jal  UpdateTailAuto
	j    PlayLoop
    
Left: #Mueve la serpiente automaticamente hacia la izquierda
	addi $s2, $s2, -1
	sw   $s2, HeadX
	jal  CalcPos
	blt  $s2, 0, GameOver #Verifica si toca un borde
	jal  SetPixel
	jal  UpdateTailAuto
	j    PlayLoop

UpdateTailAuto: #Actualizar la cola con el movimiento automatico de la serpiente
	lw   $t8, tail
	li   $t7, 0x008080 #Color de fondo (turquesa)
	sw   $t7, ($t8)
   	sw   $t6, tail
	li   $t7, 0x00FF00 #Color de la serpiente (verde lima)
	jr   $ra
    
SetPlayer: #Colocar al jugador al inicio del juego
	move $t9, $ra
	li   $s1, 1
	li   $s2, 1
	jal  CalcPos
	sw   $t6, tail #Inicializa la posicion de la cola
	li   $t7, 0x00FF00
	jal  SetPixel
	sw   $s1, HeadY
	sw   $s2, HeadX
	jr   $t9

SetFruit:
	li $t7, 0xFF0000
	#Se calcula y
	li   $a1, 32 
	li   $v0, 42
	syscall
    
	move $s1, $a0
	sw   $s1, FruitY
      
	#Se calcula x
	li   $a1, 32 
	li   $v0, 42
	syscall
     
	move $s2, $a0
	sw	$s2, FruitX
     
	jal  CalcPos
	jal  SetPixel
	lw   $s1, HeadY
	lw	$s2, HeadX
	li	$t3, 1 #Establecer que ya hay una fruta
	li   $t7, 0x00FF00
	j	PlayLoop
    
SetPixel: #Aplica un color a un pixel especifico (Recibe posicion, color)
	sw   $t7, ($t6)
	jr   $ra
    
CalcPos: #Calcular posicion en el bitmap (Recibe x, y)
	li   $t4, 32  
	mul  $t5, $t4, $s1  
	add  $t5, $t5, $s2  
	sll  $t5, $t5, 2   
	la   $t6, display    
	add  $t6, $t6, $t5  #t6 es la posicion en el bitmap    
	jr   $ra
     
SetBG: #Crea el background del tablero
	beq  $t1, 4096, EndLoop 
	li   $t0 0x008080 #Aplica el color turquesa
	sw   $t0, display($t1)
	addi $t1, $t1, 4
	j    SetBG
EndLoop:
	li   $t1 0 #Reinicia el contador
	jr   $ra
