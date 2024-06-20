.data
display: .space 1024   # Reserva espacio para el display (256 palabras)
.text
.globl main
main:
    li $t1, 0 #Inicializa el contador 
    jal SetBG #Crea el fondo del juego 
    
    li $a0, 1 #x
    li $a1, 1 #y
    jal CalcPos 
    li $t7 0xFF0000
    jal SetPixel
    
    li $v0, 10       
    syscall
SetPixel: #Aplica un color a un pixel especifico (Recibe posicion, color)
	sw $t7, ($t6)
	jr $ra
CalcPos: #Calcular posicion en el bitmap (Recibe x, y)
	li $t4, 16        
	mul $t5, $t4, $a1  
	add $t5, $t5, $a0  
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

	
	
