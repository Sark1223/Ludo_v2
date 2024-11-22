extends Node2D


var posiciones = [
	#cuadrante 1 - horizontal_derecha
	Vector2(-19,0), Vector2(-16,0), Vector2(-13, 0), Vector2(-10, 0), Vector2(-07, 0), Vector2(-04,0),
	#   0				1				2				3					4					5 
	#cuadrante 1 - vertical_arriba
	Vector2(-04, -02), Vector2(-4, -5), Vector2(-04,-08), Vector2(-04,-011), Vector2(-04, -14),  
	#   6					7				8					9					10			
	#cuadrante 1/2 - horizontal_derecha
	Vector2(-1, -14), Vector2(2, -14), 
	#	11					12
	##cuadrante 2 - vertical_abajo
	Vector2(2, -13),Vector2(2,-10), Vector2(2,-7), Vector2(2, -4),Vector2(2, -1),
	#	13				14				15				16				17
	##cuadrante 2 - horizontal_derecha
	Vector2(5, 0), Vector2(8, 0),Vector2(11, 0), Vector2(14, 0), Vector2(17, 0), 
	#	18				19			20				21					22
	#cuadrante 2/3 - vertical_abajo
	Vector2(17, 2), Vector2(17, 5), 
	#	23				24
	#cuadrante 3 - horizontal_izquierda
	Vector2(16, 6), Vector2(13, 6),Vector2(10, 6), Vector2(7, 6), Vector2(4,6),
	#	25				26				27				28				29
	#cuadrante 3 - vertical_abajo
	Vector2(2, 8), Vector2(2, 11),Vector2(2, 14),Vector2(2, 17),Vector2(2, 20),
	#	30				31				32			33				34
	#cuadrante 3/4
	Vector2(1, 21),Vector2(-2, 21),
	#	35				36
	#cuadrante 4 - vertical_arriba
	Vector2(-4, 19),Vector2(-4, 16), Vector2(-4, 13), Vector2(-4, 10), Vector2(-4, 7), 
	#	37				38				39					40				41
	#cuadrante 4 - horizontal_izquierda
	Vector2(-5, 6), Vector2(-8, 6), Vector2(-11, 4), Vector2(-14,6),	Vector2(-17,6),
	#	42				43				44				45					46
	#cuadrante 4/1
	Vector2(-19, 4)]
	#	47

var posicionesInicio = [Vector2(-4,19), Vector2(16,6), Vector2(2,-13), Vector2(-16,0)]
	
	#empieza en el 37
var posicionesValidasP1 =[
	posiciones[38], posiciones[39], posiciones[40], posiciones[41],posiciones[42], posiciones[43], posiciones[44], posiciones[45], posiciones[46], posiciones[47],
	posiciones[0], posiciones[1], posiciones[2], posiciones[3], posiciones[4], posiciones[5], posiciones[6], posiciones[7], posiciones[8], posiciones[9],
	posiciones[10], posiciones[11],	posiciones[12],posiciones[13],posiciones[14],posiciones[15],posiciones[16],posiciones[17],posiciones[18],posiciones[19], 
	posiciones[20], posiciones[21],	posiciones[22],posiciones[23],posiciones[24],posiciones[25],posiciones[26],posiciones[27],posiciones[28],posiciones[29],
	posiciones[30],	posiciones[31],	posiciones[32],posiciones[33],posiciones[34],posiciones[35],
	Vector2(0, 19), Vector2(0, 16), Vector2(0, 13), Vector2(0, 10), Vector2(0, 7), Vector2(0, 4)]

	#empieza en el 25
var posicionesValidasP2 =[
	posiciones[26],posiciones[27],posiciones[28],posiciones[29],posiciones[30],	posiciones[31],posiciones[32],posiciones[33],posiciones[34],posiciones[35],
	posiciones[36],posiciones[37], posiciones[38], posiciones[39], posiciones[40], posiciones[41],posiciones[42], posiciones[43],posiciones[44], posiciones[45],
	posiciones[46], posiciones[47],	posiciones[0], posiciones[1], posiciones[2], posiciones[3], posiciones[4], posiciones[5], posiciones[6], posiciones[7], 
	posiciones[8], posiciones[9],	posiciones[10], posiciones[11],posiciones[12],posiciones[13],posiciones[14],posiciones[15],posiciones[16],posiciones[17],
	posiciones[18],posiciones[19], posiciones[20], posiciones[21],posiciones[22],posiciones[23],
	Vector2(16, 3), Vector2(13, 3), Vector2(10, 3), Vector2(7, 3), Vector2(4, 3), Vector2(1, 1)]

	#empieza en el 15
var posicionesValidasP3 =[
	posiciones[14],posiciones[15],posiciones[16],posiciones[17],posiciones[18],posiciones[19], posiciones[20], posiciones[21],posiciones[22],posiciones[23],
	posiciones[24],posiciones[25],posiciones[26],posiciones[27],posiciones[28],posiciones[29],posiciones[30],	posiciones[31],posiciones[32],posiciones[33],
	posiciones[34],posiciones[35],posiciones[36],posiciones[37], posiciones[38], posiciones[39], posiciones[40], posiciones[41],posiciones[42], posiciones[43],
	posiciones[44], posiciones[45], posiciones[46], posiciones[47],	posiciones[0], posiciones[1], posiciones[2], posiciones[3], posiciones[4], posiciones[5], 
	posiciones[6], posiciones[7], posiciones[8], posiciones[9],	posiciones[10], posiciones[11],
	Vector2(0, -13), Vector2(0, -10), Vector2(0, -7), Vector2(0, -4), Vector2(-0, -1), Vector2(0, 2)]

	#empieza en el 1
var posicionesValidasP4 =[
	posiciones[2],posiciones[3],posiciones[4],posiciones[5],posiciones[6],posiciones[7],posiciones[8],posiciones[9],posiciones[10], posiciones[11],
	posiciones[12],posiciones[13],posiciones[14],posiciones[15],posiciones[16],posiciones[17],posiciones[18],posiciones[19], posiciones[20], posiciones[21],
	posiciones[22],posiciones[23],posiciones[24],posiciones[25],posiciones[26],posiciones[27],posiciones[28],posiciones[29],posiciones[30],	posiciones[31],
	posiciones[32],posiciones[33],posiciones[34],posiciones[35],posiciones[36],posiciones[37], posiciones[38], posiciones[39], posiciones[40], posiciones[41],
	posiciones[42], posiciones[43], posiciones[44], posiciones[45], posiciones[46], posiciones[47],
	Vector2(-16,3), Vector2(-13,3), Vector2(-10,3), Vector2(-7,3), Vector2(-4,3), Vector2(-1,2)]
