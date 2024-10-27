using Godot;
using System;

public partial class Mapa2 : Control
{
	private int dado; // Valor del dado
	private Node2D piezaJugador; // Referencia a la pieza del jugador actual

	// Variables que indican si las piezas de cada jugador han salido de casa
	private bool[] piezasHanSalidoDeCasa = new bool[4]; // Una para cada jugador

	private int turnoActual = 1; // El turno comienza con el jugador 1
	private int totalJugadores = 4; // Cantidad de jugadores

	// Índices de posición para cada jugador
	private int[] posicionesActualesIndex = new int[4] { -1, -1, -1, -1 }; // Empieza en -1 (no han salido de casa)

	private Vector2[] posicionValidaJ1 = {
		new Vector2(1, 23), new Vector2(1, 19), new Vector2(5, 19), new Vector2(9, 19), new Vector2(13, 19), new Vector2(17, 19),
		new Vector2(20, 17), new Vector2(20, 13), new Vector2(20, 9), new Vector2(20, 4), new Vector2(20, 1), new Vector2(20, -3), new Vector2(20, -7), new Vector2(20, -11), new Vector2(20, -15),
		new Vector2(17, -16), new Vector2(13, -16), new Vector2(9, -16), new Vector2(5, -16), new Vector2(1, -16), new Vector2(-3, -16), new Vector2(-7, -16), new Vector2(-11, -16), new Vector2(-15, -16),
		new Vector2(-18, -15), new Vector2(-18, -11), new Vector2(-18, -7), new Vector2(-18, -3), new Vector2(-18, 1), new Vector2(-18, 5), new Vector2(-18, 9), new Vector2(-18, 13), new Vector2(-18, 17),
		new Vector2(-15, 19), new Vector2(-11, 19), new Vector2(-7, 19), new Vector2(-3, 19), new Vector2(1, 19), new Vector2(1, 15), new Vector2(1, 11), new Vector2(1, 7), new Vector2(1, 1)
	};

	private Vector2[] posicionValidaJ2 = {
		new Vector2(24, 1), new Vector2(20, 1), new Vector2(20, -3), new Vector2(20, -7), new Vector2(20, -11), new Vector2(20, -15),
		new Vector2(17, -16), new Vector2(13, -16), new Vector2(9, -16), new Vector2(5, -16), new Vector2(1, -16), new Vector2(-3, -16), new Vector2(-7, -16), new Vector2(-11, -16), new Vector2(-15, -16),
		new Vector2(-18, -15), new Vector2(-18, -11), new Vector2(-18, -7), new Vector2(-18, -3), new Vector2(-18, 1), new Vector2(-18, 5), new Vector2(-18, 9), new Vector2(-18, 13), new Vector2(-18, 17),
		new Vector2(-15, 19), new Vector2(-11, 19), new Vector2(-7, 19), new Vector2(-3, 19), new Vector2(1, 19), new Vector2(5, 19), new Vector2(9, 19), new Vector2(13, 19), new Vector2(17, 19),
		new Vector2(20, 17), new Vector2(20, 13), new Vector2(20, 9), new Vector2(20, 4), new Vector2(20, 1), new Vector2(16, 1), new Vector2(12, 1), new Vector2(8, 1), new Vector2(1, 1)
	};

	private Vector2[] posicionValidaJ3 = {
		new Vector2(1, -20), new Vector2(1, -16), new Vector2(-3, -16), new Vector2(-7, -16), new Vector2(-11, -16), new Vector2(-15, -16),
		new Vector2(-18, -15), new Vector2(-18, -11), new Vector2(-18, -7), new Vector2(-18, -3), new Vector2(-18, 1), new Vector2(-18, 5), new Vector2(-18, 9), new Vector2(-18, 13), new Vector2(-18, 17),
		new Vector2(-15, 19), new Vector2(-11, 19), new Vector2(-7, 19), new Vector2(-3, 19), new Vector2(1, 19), new Vector2(5, 19), new Vector2(9, 19), new Vector2(13, 19), new Vector2(17, 19),
		new Vector2(20, 17), new Vector2(20, 13), new Vector2(20, 9), new Vector2(20, 4), new Vector2(20, 1), new Vector2(20, -3), new Vector2(20, -7), new Vector2(20, -11), new Vector2(20, -15),
		new Vector2(17, -16), new Vector2(13, -16), new Vector2(9, -16), new Vector2(5, -16), new Vector2(1, -16), new Vector2(1, -12), new Vector2(1, -8), new Vector2(1, -4), new Vector2(1, 1)
	};

	private Vector2[] posicionValidaJ4 = {
		new Vector2(-22, 1), new Vector2(-18, 1), new Vector2(-18, 5), new Vector2(-18, 9), new Vector2(-18, 13), new Vector2(-18, 17),
		new Vector2(-15, 19), new Vector2(-11, 19), new Vector2(-7, 19), new Vector2(-3, 19), new Vector2(1, 19), new Vector2(5, 19), new Vector2(9, 19), new Vector2(13, 19), new Vector2(17, 19),
		new Vector2(20, 17), new Vector2(20, 13), new Vector2(20, 9), new Vector2(20, 4), new Vector2(20, 1), new Vector2(20, -3), new Vector2(20, -7), new Vector2(20, -11), new Vector2(20, -15),
		new Vector2(17, -16), new Vector2(13, -16), new Vector2(9, -16), new Vector2(5, -16), new Vector2(1, -16), new Vector2(-3, -16), new Vector2(-7, -16), new Vector2(-11, -16), new Vector2(-15, -16),
		new Vector2(-18, -15), new Vector2(-18, -11), new Vector2(-18, -7), new Vector2(-18, -3), new Vector2(-18, 1), new Vector2(-14, 1), new Vector2(-10, 1), new Vector2(-6, 1), new Vector2(1, 1)
	};  
	public void _Ready()
	{
		// Inicializa la pieza del jugador actual (Jugador 1 comienza)
		piezaJugador = GetNode<Node2D>("J1P1");
		Button boton = GetNode<Button>("TirarDado");
		boton.Connect("pressed", Callable.From(OnDiceButtonPressed));
	}

	private void OnDiceButtonPressed()
	{
		TirarDado();
	}

	private void TirarDado()
	{
		Random rand = new Random();
		dado = rand.Next(1, 7); // Genera un valor entre 1 y 6
		GD.Print($"Jugador {turnoActual} lanzó el dado: {dado}");

		// Mueve la pieza del jugador actual
		MoverPieza(dado);
	}

	 private void MoverPieza(int pasos)
	{
		// Obtiene las posiciones válidas para el jugador actual
		Vector2[] posicionesValidas = ObtenerPosicionesValidasJugador(turnoActual);

		if (!piezasHanSalidoDeCasa[turnoActual - 1])
		{
			// Si la pieza del jugador no ha salido de casa, verifica si cae un 6
			if (dado == 6)
			{
				piezasHanSalidoDeCasa[turnoActual - 1] = true; // Marca que la pieza ha salido de la casa
				posicionesActualesIndex[turnoActual - 1] = 0; // Empieza en la primera posición válida
				Vector2 nuevaPos = posicionesValidas[posicionesActualesIndex[turnoActual - 1]];
				MoverPosicion(nuevaPos);
				GD.Print($"La pieza del Jugador {turnoActual} ha salido de casa.");
			}
			else
			{
				GD.Print($"Jugador {turnoActual} necesita un 6 para salir de casa.");
			}
		}
		else
		{
			// Si la pieza ya ha salido de la casa, realiza el movimiento normal
			if (posicionesActualesIndex[turnoActual - 1] + pasos < posicionesValidas.Length)
			{
				posicionesActualesIndex[turnoActual - 1] += pasos;
				Vector2 nuevaPos = posicionesValidas[posicionesActualesIndex[turnoActual - 1]] * 15.9f;
				MoverPosicion(nuevaPos);
				GD.Print($"Pieza del Jugador {turnoActual} se movió a la posición: {posicionesActualesIndex[turnoActual - 1]}");
			}
			else
			{
				GD.Print($"Jugador {turnoActual} no puede moverse fuera del tablero.");
			}
		}

		// Cambia el turno al siguiente jugador
		CambiarTurno();
	}

	private void MoverPosicion(Vector2 nuevaPos)
	{
		piezaJugador.Position = nuevaPos;
		GD.Print($"Pieza movida a: {nuevaPos}");
	}

	private void CambiarTurno()
	{
		// Cambia el turno al siguiente jugador
		turnoActual += 1;
		if (turnoActual > totalJugadores)
		{
			turnoActual = 1; // Vuelve al jugador 1 si ya pasaron todos los jugadores
		}

		GD.Print($"Es el turno del Jugador {turnoActual}");

		// Actualiza la pieza del jugador actual
		piezaJugador = GetPiezaJugador(turnoActual);
	}


	// Este método devuelve las posiciones válidas según el jugador actual
	private Vector2[] ObtenerPosicionesValidasJugador(int jugador)
	{
		switch (jugador)
		{
			case 1: return posicionValidaJ1;
			case 2: return posicionValidaJ2;
			case 3: return posicionValidaJ3;
			case 4: return posicionValidaJ4;
			default: return posicionValidaJ1;
		}
	}

	// Este método devuelve la referencia a la pieza del jugador actual
	private Node2D GetPiezaJugador(int jugador)
	{
		switch (jugador)
		{
			case 1: return GetNode<Node2D>("/root/Control/J1P1"); // Referencia a la pieza del jugador 1 (puedes cambiar esto según los nombres de tus piezas)
			case 2: return GetNode<Node2D>("/root/Control/J2P1"); // Referencia a la pieza del jugador 2
			case 3: return GetNode<Node2D>("/root/Control/J3P1"); // Referencia a la pieza del jugador 3
			case 4: return GetNode<Node2D>("/root/Control/J4P1"); // Referencia a la pieza del jugador 4
			default: return GetNode<Node2D>("/root/Control/J1P1");
		}
	}
}
