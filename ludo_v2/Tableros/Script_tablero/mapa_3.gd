extends Node2D

#Codigo NO TERMINADO

var posiciones = [
	Vector2(560,575), Vector2(464, 575), Vector2(368, 575), Vector2(272,575), Vector2(176,575), Vector2(112, 496), Vector2(112, 416), Vector2(112, 344), Vector2(112, 272),  Vector2(112, 192), Vector2(176, 111), Vector2(272, 111),Vector2(368, 111),Vector2(464, 111),Vector2(560, 111),Vector2(656, 111),Vector2(752, 111),Vector2(848, 111),Vector2(944, 111),Vector2(1009, 192),Vector2(1009, 192),Vector2(1009, 272),Vector2(1009, 344),Vector2(1009, 416),Vector2(1009, 496),Vector2(944, 575),Vector2(848, 575),Vector2(752, 575),Vector2(656, 575),Vector2(560, 575),
	Vector2(560, 464),Vector2(560, 416),Vector2(495, 416),Vector2(432, 416),Vector2(240, 352),Vector2(240, 224), Vector2(304, 224),Vector2(432, 224),Vector2(496, 224),Vector2(560, 224),Vector2(624, 224),Vector2(688, 224),Vector2(752, 224),Vector2(816, 224),Vector2(880, 224), Vector2(880, 287), Vector2(880, 353),Vector2(880, 416), Vector2(816, 416),Vector2(752, 416), Vector2(688, 416),Vector2(624, 416),Vector2(560, 416),
	Vector2(560,348)
]
var posicionInicio=Vector2(560,600)

var dado
var turnoActual = 1
var totalJugadores = 4
var jugadores = {}
var pieza_seleccionada = null
var indice_pieza_seleccionada = null

var PosicionGanar = Vector2(1,1)

func _ready():
	var boton = $TirarDado
	boton.connect("pressed", Callable(self, "_on_dice_button_pressed"))

	# Inicializar jugadores y sus piezas
	jugadores[1] = {
		"piezas": [],
		"posiciones": [],
		"han_salido": []
	}
	jugadores[2] = {
		"piezas": [],
		"posiciones": [],
		"han_salido": []
	}

"""
	# Configurar piezas del Jugador 1 (gatito)
	for i in range(1, 5):
		var pieza_nombre = "gatito" + (str(i) if i > 1 else "")
		var pieza = get_node("%s" % pieza_nombre)
		jugadores[1]["piezas"].append(pieza)
		jugadores[1]["posiciones"].append(-1)
		jugadores[1]["han_salido"].append(false)
		pieza.connect("piece_clicked", Callable(self, "_on_pieza_seleccionada"))

	# Configurar piezas del Jugador 2 (sombrero)
	for i in range(1, 5):
		var pieza_nombre = "sombrero" + (str(i) if i > 1 else "")
		var pieza = get_node("%s" % pieza_nombre)
		jugadores[2]["piezas"].append(pieza)
		jugadores[2]["posiciones"].append(-1)
		jugadores[2]["han_salido"].append(false)
		pieza.connect("piece_clicked", Callable(self, "_on_pieza_seleccionada"))
		
	
"""
func _on_tirar_dado_pressed() -> void: 
	tirar_dado()
	print("Selecciona una de tus piezas para mover.")

func tirar_dado():
	dado = randi() % 6 + 1
	print("Jugador ", turnoActual, " lanzó el dado: ", dado)

func _on_pieza_seleccionada(jugador_num, indice_pieza):
	print("Signal received: jugador_num=", jugador_num, ", indice_pieza=", indice_pieza)
	if turnoActual == jugador_num:
		pieza_seleccionada = jugadores[jugador_num]["piezas"][indice_pieza]
		indice_pieza_seleccionada = indice_pieza
		print("Pieza del Jugador %d, índice %d seleccionada." % [jugador_num, indice_pieza])
		mover_pieza(dado)
	else:
		print("No es tu turno. Es el turno del Jugador %d." % turnoActual)

func mover_pieza(pasos):
	if pieza_seleccionada == null:
		print("Debes seleccionar una pieza para mover.")
		return

	var jugador = turnoActual
	var indice_pieza = indice_pieza_seleccionada
	var posicion_index = jugadores[jugador]["posiciones"][indice_pieza]
	var ha_salido = jugadores[jugador]["han_salido"][indice_pieza]

	if not ha_salido:
		if dado == 6:
			jugadores[jugador]["han_salido"][indice_pieza] = true
			posicion_index = 0
			jugadores[jugador]["posiciones"][indice_pieza] = posicion_index
			var nueva_pos = posicionInicio[jugador - 1] * 15.9
			mover_posicion(pieza_seleccionada, nueva_pos)
			print("La pieza ha salido de casa.")
		else:
			print("Necesitas un 6 para sacar esta pieza.")
			return
	else:
		if posicion_index + pasos < posiciones.size():
			posicion_index += pasos
			jugadores[jugador]["posiciones"][indice_pieza] = posicion_index
			var nueva_pos = posiciones[posicion_index] * 15.9
			mover_posicion(pieza_seleccionada, nueva_pos)
			print("Pieza movida a la posición: ", posicion_index)
			verificar_victoria(pieza_seleccionada, nueva_pos)
		else:
			print("No puedes moverte fuera del tablero.")

	pieza_seleccionada = null
	indice_pieza_seleccionada = null
	cambiar_turno()


func mover_posicion(pieza, nueva_pos):
	if pieza != null:
		pieza.position = nueva_pos
		print("Pieza movida a: ", nueva_pos)
	else:
		print("Error: La pieza es null.")

func cambiar_turno():
	turnoActual += 1
	if turnoActual > totalJugadores:
		turnoActual = 1
	print("Es el turno del Jugador ", turnoActual)

func verificar_victoria(pieza, nueva_pos):
	if nueva_pos == PosicionGanar * 15.9:
		print("¡Jugador ", turnoActual, " ha ganado con una de sus piezas!")
		# Implementar lógica adicional si es necesario

 
