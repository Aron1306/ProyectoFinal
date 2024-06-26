Descripción del proyecto:
El programa está basado en los juegos tipo “Snake” donde el jugador intenta consumir la
mayor cantidad de frutas sin chocar con alguno de los bordes del juego o su propio cuerpo.
En este programa, se toman las características del Snake original como el espacio de juego o
tablero, la generación de frutas, y la colisión con los muros, pero se reemplaza el aumento
del tamaño con un aumento de velocidad por cada fruta consumida.
Para el juego se utiliza el Bitmap Display de Mars para mostrar el tablero, las frutas y el
jugador, además del Keyboard and Display MMIO Simulator para tomar las entradas del
usuario y la consola para mostrar la puntuación final.
Durante el juego, se utiliza al personaje (pixel verde) para intentar consumir la mayor
cantidad de frutas (pixeles rojos) a la vez que se evita chocar con un borde, entre mayor sea
la puntuación, más complicado es consumirlas y más fácil chocar a causa del aumento de
velocidad por cada fruta

Instrucciones para la utilización programa

Instrucciones previas al juego:
1. Abrir el archivo .asm.
2. Activar las herramientas del Bitmap Display y Keyboard and Display MMIO
Simulator
3. Configurar el Bitmap Display de la siguiente manera:
    -Unit Width in Pixels: 16
    -Unit Height in Pixels: 16
    -Display Width in Pixels: 512
    -Display Height in Pixels: 512
    -Base address for display: 0x10010000 (static data)
5. Conectar ambas herramientas a MIPS.

Instrucciones del juego:
1. Correr el programa y seleccionar la sección de “Keyboard” del simulador (El juego
no reconocerá el teclado si no se tiene seleccionado).
2. Para el movimiento del jugador: “w” para arriba, “a” para izquierda, “s” para abajo y
“d” para la derecha.
3. No es posible moverse en una dirección completamente contraria con solo un
movimiento. Ejemplo: Si la dirección actual es hacia abajo, no se puede ir
inmediatamente hacia arriba, se debe ir hacia la derecha o la izquierda primero.
4. Si se choca con un borde el juego termina.
5. El objetivo es conseguir la mayor cantidad de frutas sin chocar con un borde.
6. La velocidad aumentará por cada fruta que consuma el jugador.
7. La puntuación final se mostrará en la consola cuando el jugador pierda.
8. Para volver a jugar repita el paso 1.

