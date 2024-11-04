using Godot;
using System;

public partial class mapa1 : Node2D
{
	//MAPA COMPLETO
	private Vector2[]  posiciones_mapa =
	{
		// cuadrante 1 - horizontal_derecha
		/*0*/new Vector2(-19, 0),/*1*/ new Vector2(-16, 0),/*2*/ new Vector2(-13, 0), /*3*/new Vector2(-10, 0), /*4*/new Vector2(-7, 0), /*5*/new Vector2(-4, 0),
		// cuadrante 1 - vertical_arriba
		/*6*/new Vector2(-4, -2), /*7*/new Vector2(-4, -5), /*8*/new Vector2(-4, -8), /*9*/new Vector2(-4, -11), /*10*/new Vector2(-4, -14),
		// cuadrante 1/2 - horizontal_derecha
		/*11*/new Vector2(-1, -14), /*12*/new Vector2(2, -14),
		// cuadrante 2 - vertical_abajo
		/*13*/new Vector2(2, -13), /*14*/new Vector2(2, -10), /*15*/new Vector2(2, -7), /*16*/new Vector2(2, -4), /*17*/new Vector2(2, -1),
		// cuadrante 2 - horizontal_derecha
		/*18*/new Vector2(5, 0), /*19*/new Vector2(8, 0), /*20*/new Vector2(11, 0), /*21*/new Vector2(14, 0),/*22*/new Vector2(17, 0),
		// cuadrante 2/3 - vertical_abajo
		/*23*/new Vector2(17, 2), /*24*/new Vector2(17, 5),
		// cuadrante 3 - horizontal_izquierda
		/*25*/new Vector2(16, 6), /*26*/new Vector2(13, 6), /*27*/new Vector2(10, 6), /*28*/new Vector2(7, 6), /*29*/new Vector2(4, 6),
		// cuadrante 3 - vertical_abajo
		/*30*/new Vector2(2, 8), /*31*/new Vector2(2, 11), /*32*/new Vector2(2, 14), /*33*/new Vector2(2, 17), /*34*/new Vector2(2, 20),
		// cuadrante 3/4
		/*35*/new Vector2(1, 21), /*36*/new Vector2(-2, 21),
		// cuadrante 4 - vertical_arriba
		/*37*/new Vector2(-4, 19), /*38*/new Vector2(-4, 16), /*39*/new Vector2(-4, 13), /*40*/new Vector2(-4, 10), /*41*/new Vector2(-4, 7),
		// cuadrante 4 - horizontal_izquierda
		/*42*/new Vector2(-5, 6), /*43*/new Vector2(-8, 6), /*44*/new Vector2(-11, 4), /*45*/new Vector2(-14, 6), /*46*/new Vector2(-17, 6),
		// cuadrante 4/1
		/*47*/new Vector2(-19, 4)
	};
	
	//GANAR JUGADOR 1
	private Vector2[]  posiciones_ganador_1 =
	{/*1*/new Vector2(-16, 3),/*2*/new Vector2(-13, 3),/*3*/new Vector2(-10, 3),/*4*/new Vector2(-7, 3),/*5*/new Vector2(-4, 3)};
	//GANAR JUGADOR 2
	//GANAR JUGADOR 3
	//GANAR JUGADOR 4
	
	
	//Posiciones validas de J1 
		// [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 
		// 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41,1 42, 43, 44, 45, 46, 47];
	public override void _Ready()
	{
		// Código para inicializar si es necesario
	}
}
