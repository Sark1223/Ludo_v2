extends Node

var dado # Valor del dado
var piezaJugador # Referencia al jugador
var turnoActual = 1 # Turno del jugador actual (1-4)
var totalJugadores = 4 # Número total de jugadores
var posicionActualIndex = [-1, -1, -1, -1] # Índice de la posición actual para cada jugador
var piezasHanSalidoDeCasa = [false, false, false, false] # Estado de cada pieza

var posicionValidaJ1 = [
	Vector2(1,23), Vector2(1,19), Vector2(5,19), Vector2(9,19), Vector2(13,19), Vector2(17,19),
	Vector2(20,17), Vector2(20,13), Vector2(20,9), Vector2(20,4), Vector2(20,1),Vector2(20,-3), Vector2(20,-7), Vector2(20,-11),Vector2(20,-15),
	Vector2(17,-16), Vector2(13,-16),Vector2(9,-16), Vector2(5,-16), Vector2(1,-16), Vector2(-3,-16), Vector2(-7,-16), Vector2(-11,-16), Vector2(-15,-16),
	Vector2(-18,-15), Vector2(-18,-11),Vector2(-18,-7),Vector2(-18,-3),Vector2(-18,1),Vector2(-18,5),Vector2(-18,9),Vector2(-18,13),Vector2(-18,17),
	Vector2(-15,19), Vector2(-11,19),Vector2(-7,19),Vector2(-3,19), Vector2(1,19), Vector2(1,15), Vector2(1,11), Vector2(1,7),	Vector2(1,1)
]

var posicionValidaJ2 = [
	Vector2(24,1),Vector2(20,1), Vector2(20,-3), Vector2(20,-7), Vector2(20,-11),Vector2(20,-15),
	Vector2(17,-16), Vector2(13,-16),Vector2(9,-16), Vector2(5,-16), Vector2(1,-16), Vector2(-3,-16), Vector2(-7,-16), Vector2(-11,-16), Vector2(-15,-16),
	Vector2(-18,-15), Vector2(-18,-11),Vector2(-18,-7),Vector2(-18,-3),Vector2(-18,1),Vector2(-18,5),Vector2(-18,9),Vector2(-18,13),Vector2(-18,17),
	Vector2(-15,19), Vector2(-11,19),Vector2(-7,19),Vector2(-3,19), Vector2(1,19), Vector2(5,19), Vector2(9,19), Vector2(13,19), Vector2(17,19),
	Vector2(20,17), Vector2(20,13), Vector2(20,9), Vector2(20,4), Vector2(20,1), Vector2(16,1), Vector2(12,1), Vector2(8,1), 	Vector2(1,1)
	]
	
var posicionValidaJ3 = [
	Vector2(1,-20), Vector2(1,-16), Vector2(-3,-16), Vector2(-7,-16), Vector2(-11,-16), Vector2(-15,-16),
	Vector2(-18,-15), Vector2(-18,-11),Vector2(-18,-7),Vector2(-18,-3),Vector2(-18,1),Vector2(-18,5),Vector2(-18,9),Vector2(-18,13),Vector2(-18,17),
	Vector2(-15,19), Vector2(-11,19),Vector2(-7,19),Vector2(-3,19), Vector2(1,19), Vector2(5,19), Vector2(9,19), Vector2(13,19), Vector2(17,19),
	Vector2(20,17), Vector2(20,13), Vector2(20,9), Vector2(20,4), Vector2(20,1), Vector2(20,-3), Vector2(20,-7), Vector2(20,-11),Vector2(20,-15),
	Vector2(17,-16), Vector2(13,-16),Vector2(9,-16), Vector2(5,-16), Vector2(1,-16), Vector2(1,-12), Vector2(1,-8), Vector2(1,-4),
	Vector2(1,1)
]

var posicionValidaJ4 = [
	Vector2(-22,1),Vector2(-18,1),Vector2(-18,5),Vector2(-18,9),Vector2(-18,13),Vector2(-18,17),
	Vector2(-15,19), Vector2(-11,19),Vector2(-7,19),Vector2(-3,19), Vector2(1,19), Vector2(5,19), Vector2(9,19), Vector2(13,19), Vector2(17,19),
	Vector2(20,17), Vector2(20,13), Vector2(20,9), Vector2(20,4), Vector2(20,1), Vector2(20,-3), Vector2(20,-7), Vector2(20,-11),Vector2(20,-15),
	Vector2(17,-16), Vector2(13,-16),Vector2(9,-16), Vector2(5,-16), Vector2(1,-16), Vector2(-3,-16), Vector2(-7,-16), Vector2(-11,-16), Vector2(-15,-16),
	Vector2(-18,-15), Vector2(-18,-11),Vector2(-18,-7),Vector2(-18,-3),Vector2(-18,1), Vector2(-14,1), Vector2(-10,1), Vector2(-6,1),	Vector2(1,1)
]	
var posicionInicio = [
	Vector2(1,23), Vector2(24,1), Vector2(1,-20), Vector2(-22,1)
]

var PosicionGanar = Vector2(1,1)

# Función para obtener las posiciones válidas de un jugador según su número
func obtener_posiciones_validas(jugador):
	match jugador:
		1:
			return posicionValidaJ1
		2:
			return posicionValidaJ2
		3:
			return posicionValidaJ3
		4:
			return posicionValidaJ4
		_:
			return posicionValidaJ1

# Función para tirar el dado y mover la pieza del jugador actual
func tirar_dado():
	dado = randi() % 6 + 1
	print("Jugador ", turnoActual, " lanzó el dado: ", dado)
	mover_pieza(dado)

func _ready() -> void:
	piezaJugador = get_pieza_jugador(turnoActual)
	var boton = $TirarDado
	boton.connect("pressed", Callable(self, "_on_dice_button_pressed"))

func _on_dice_button_pressed():
	tirar_dado()

func mover_pieza(pasos):
	var posiciones_validas = obtener_posiciones_validas(turnoActual)
	if not piezasHanSalidoDeCasa[turnoActual - 1]:
		if dado == 6:
			piezasHanSalidoDeCasa[turnoActual - 1] = true
			posicionActualIndex[turnoActual - 1] = 0
			var nueva_pos = posicionInicio[turnoActual - 1] * 15.9 # Usa la posición de inicio correspondiente
			mover_posicion(nueva_pos)
			print("La pieza del Jugador ", turnoActual, " ha salido de casa.")
		else:
			print("Jugador ", turnoActual, " necesita un 6 para salir de casa.")
	else:
		if posicionActualIndex[turnoActual - 1] + pasos < posiciones_validas.size():
			posicionActualIndex[turnoActual - 1] += pasos
			var nueva_pos = posiciones_validas[posicionActualIndex[turnoActual - 1]] * 15.9
			mover_posicion(nueva_pos)
			print("Pieza del Jugador ", turnoActual, " se movió a la posición: ", posicionActualIndex[turnoActual - 1])
			verificar_victoria(nueva_pos)
		else:
			print("Jugador ", turnoActual, " no puede moverse fuera del tablero.")

	cambiar_turno()

func mover_posicion(nueva_pos):
	piezaJugador.position = nueva_pos
	print("Pieza movida a: ", nueva_pos)

func cambiar_turno():
	turnoActual += 1
	if turnoActual > totalJugadores:
		turnoActual = 1
	print("Es el turno del Jugador ", turnoActual)
	piezaJugador = get_pieza_jugador(turnoActual)

func get_pieza_jugador(jugador):
	match jugador:
		1:
			return $Cat
		2:
			return $Dog
		3:
			return $Turtle
		4:
			return $Monkey
		_:
			return $Cat

func verificar_victoria(nueva_pos):
	if nueva_pos == PosicionGanar:
		print("¡Jugador ", turnoActual, " ha ganado!")
