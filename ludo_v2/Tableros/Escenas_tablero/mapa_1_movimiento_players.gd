extends Node2D


var posiciones = [
	#cuadrante 1 - horizontal_derecha
	Vector2(-19,0), Vector2(-16,0), Vector2(-13, 0), Vector2(-10, 0), Vector2(-07, 0), Vector2(-04,0), 
	#cuadrante 1 - vertical_arriba
	Vector2(-04, -02), Vector2(-4, -5), Vector2(-04,-08), Vector2(-04,-011), Vector2(-04, -14),  
	#cuadrante 1/2 - horizontal_derecha
	Vector2(-1, -14), Vector2(2, -14), 
	##cuadrante 2 - vertical_abajo
	Vector2(2, -13),Vector2(2,-10), Vector2(2,-7), Vector2(2, -4),Vector2(2, -1),
	##cuadrante 2 - horizontal_derecha
	Vector2(5, 0), Vector2(8, 0),Vector2(11, 0), Vector2(14, 0), Vector2(17, 0), 
	#cuadrante 2/3 - vertical_abajo
	Vector2(17, 2), Vector2(17, 5), 
	#cuadrante 3 - horizontal_izquierda
	Vector2(16, 6), Vector2(13, 6),Vector2(10, 6), Vector2(7, 6), Vector2(4,6),
	#cuadrante 3 - vertical_abajo
	Vector2(2, 8), Vector2(2, 11),Vector2(2, 14),Vector2(2, 17),Vector2(2, 20),
	#cuadrante 3/4
	Vector2(1, 21),Vector2(-2, 21),
	#cuadrante 4 - vertical_arriba
	Vector2(-4, 19),Vector2(-4, 16), Vector2(-4, 13), Vector2(-4, 10), Vector2(-4, 7), 
	#cuadrante 4 - horizontal_izquierda
	Vector2(-5, 6), Vector2(-8, 6), Vector2(-11, 4), Vector2(-14,6),	Vector2(-17,6),
	#cuadrante 4/1
	Vector2(-19, 4)]
