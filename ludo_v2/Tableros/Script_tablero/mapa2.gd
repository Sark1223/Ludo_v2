extends Node

var dado
var veces_dado_igual_seis = 0 
var turnoActual = 1
var totalJugadores = 2
var jugadores = {}
var pieza_seleccionada = null
var indice_pieza_seleccionada = null

var ESTADO_ESPERANDO_DADO = 0
var ESTADO_ESPERANDO_PIEZA = 1
var estado_turno = ESTADO_ESPERANDO_DADO

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

func _ready():
	# Inicializar jugadores y sus piezas
	jugadores[1] = {
		"piezas": [],
		"posiciones": [],
		"han_salido": [],
		"posiciones_iniciales": []
	}
	jugadores[2] = {
		"piezas": [],
		"posiciones": [],
		"han_salido": [],
		"posiciones_iniciales": []
	}
	# Configurar piezas del Jugador 1 (gatito)
	for i in range(1, 5):
		var pieza_nombre = "gatito" + (str(i) if i > 1 else "")
		var pieza = get_node("%s" % pieza_nombre)
		jugadores[1]["piezas"].append(pieza)
		jugadores[1]["posiciones"].append(-1)
		jugadores[1]["han_salido"].append(false)
		jugadores[1]["posiciones_iniciales"].append(pieza.position)
		pieza.connect("piece_clicked", Callable(self, "_on_pieza_seleccionada"))
		
		#Asignar jugador_num e indice_pieza a la pieza
		pieza.jugador_num = 1
		pieza.indice_pieza = i - 1 # Los indices comienzan con 0
	# Configurar piezas del Jugador 2 (sombrero)
	for i in range(1, 5):
		var pieza_nombre = "sombrero" + (str(i) if i > 1 else "")
		var pieza = get_node("%s" % pieza_nombre)
		jugadores[2]["piezas"].append(pieza)
		jugadores[2]["posiciones"].append(-1)
		jugadores[2]["han_salido"].append(false)
		jugadores[2]["posiciones_iniciales"].append(pieza.position)
		pieza.connect("piece_clicked", Callable(self, "_on_pieza_seleccionada"))

		#Asignar jugador_num e indice_pieza a la pieza
		pieza.jugador_num = 2
		pieza.indice_pieza = i - 1 # Los indices comienzan con 0
		#movimiento_completado.connect(terminar_turno)

# Funcion prueba
func tiene_piezas_en_juego(jugador):
	for ha_salido in jugadores[jugador]["han_salido"]:
		if ha_salido == true:
			return true
	return false

func tirar_dado():
	dado = randi() % 6 + 1
	if dado == 6:
		veces_dado_igual_seis = veces_dado_igual_seis + 1;

func _on_pieza_seleccionada(jugador_num, indice_pieza):
	if estado_turno != ESTADO_ESPERANDO_PIEZA:
		print("No puedes mover una pieza en este momento.")
		return
	print("Signal received: jugador_num=", jugador_num, ", indice_pieza=", indice_pieza)
	if turnoActual == jugador_num:
		var ha_salido = jugadores[jugador_num]["han_salido"][indice_pieza]
		if dado == 6 or ha_salido:
			pieza_seleccionada = jugadores[jugador_num]["piezas"][indice_pieza]
			indice_pieza_seleccionada = indice_pieza
			print("Pieza del Jugador %d, índice %d seleccionada." % [jugador_num, indice_pieza])
			mover_pieza(dado)
			#terminar_turno()
			#tirar_dado()
		else:
			print("No puedes mover esta pieza porque no ha salido y no sacaste un 6.")
	else:
		print("No es tu turno. Es el turno del Jugador %d." % turnoActual)

func mover_pieza(pasos):
	if pieza_seleccionada == null:
		print("Debes seleccionar una pieza para mover.")
		return
	if pieza_en_movimiento:
		return

	var jugador = turnoActual
	var indice_pieza = indice_pieza_seleccionada
	var posiciones_validas = obtener_posiciones_validas(jugador)
	var posicion_index = jugadores[jugador]["posiciones"][indice_pieza]
	var ha_salido = jugadores[jugador]["han_salido"][indice_pieza]

	if not ha_salido:
		# Ya hemos verificado en _on_pieza_seleccionada que dado == 6 o ha_salido == true
		jugadores[jugador]["han_salido"][indice_pieza] = true
		posicion_index = 0
		jugadores[jugador]["posiciones"][indice_pieza] = posicion_index
		var nueva_pos = posicionInicio[jugador - 1] * 15.9
		mover_posicion(pieza_seleccionada, nueva_pos)
		print("La pieza ha salido de casa.")
	else:
		if posicion_index + pasos < posiciones_validas.size():
			posicion_index += pasos
			jugadores[jugador]["posiciones"][indice_pieza] = posicion_index
			var nueva_pos = posiciones_validas[posicion_index] * 15.9
			mover_posicion(pieza_seleccionada, nueva_pos)
			print("Pieza movida a la posición: ", posicion_index)
			verificar_victoria(pieza_seleccionada, nueva_pos)
			# Verificar colisiones con otras piezas
			verificar_colision_con_otras_piezas(jugador, posicion_index)
			#terminar_turno()
		else:
			print("No puedes moverte fuera del tablero.")
			#terminar_turno()
			
func terminar_turno():
	pieza_seleccionada = null
	indice_pieza_seleccionada = null
	estado_turno = ESTADO_ESPERANDO_DADO  # Restablecer el estado para el siguiente turno
	if dado != 6 or veces_dado_igual_seis == 3:
		cambiar_turno()
		veces_dado_igual_seis = 0;
	
signal movimiento_completado


func obtener_posiciones_validas(jugador):
	match jugador:
		1:
			return posicionValidaJ1
		2:
			return posicionValidaJ2
		_:
			return []


##AUN NO FUNCIONA
func obtener_posiciones_validas_entre(pos_inicial, pos_final):
	var posiciones_validas = []
	var jugador = turnoActual
	var posiciones_validas_jugador = obtener_posiciones_validas(jugador)
	
	#buscar primera posicion valida a partir de la posicion actual
	var indice_inicial = -1
	for i in range(len(posiciones_validas_jugador)):
		if posiciones_validas_jugador[i] * 15.9 == pos_inicial:
			indice_inicial = i
			break
		
	if indice_inicial != -1:
		for i in range(indice_inicial, len(posiciones_validas_jugador)):
			posiciones_validas.append((posiciones_validas_jugador[i] * 15.9))
			if posiciones_validas_jugador[i] * 15.9 == pos_final:
				break
	
	
var pieza_en_movimiento = false

func mover_posicion(pieza, nueva_pos):
	if pieza != null:
		
		#Si la pieza ya esta en movimiento, no modificar xd
		if pieza_en_movimiento:
			return
		pieza_en_movimiento = true
		
		#guardar la posicion inicial
		var pos_inicial = pieza.position
		#determinar la direccion
		var direccion = nueva_pos - pos_inicial
		
		#reproducir animacion segun ubicacion
		if abs(direccion.y) > abs(direccion.x):
			if direccion.y >0:
				pieza.play("salto_frente")
			else:
				pieza.play("salto_atras")
		else:
			if direccion.x > 0:
				pieza.play("salto_lado")
			else:
				pieza.play("salto_lado")
		
		#obtener posiciones validas entre pA y Pb
		#var posiciones_validas = obtener_posiciones_validas_entre(pos_inicial, nueva_pos)
		
		#Crear una secuencia de tweens para movimiento suave
		var tween = create_tween()
		#for pos in posiciones_validas:
		#	tween.tween_property(pieza, "position", pos, 0.5)
		tween.tween_property(pieza, "position", nueva_pos, 2)
		
		#conectar la señal de finalizacion
		tween.finished.connect(func():
			pieza_en_movimiento = false
			#reproducir animacion segun ubicacion
			if abs(direccion.y) > abs(direccion.x):
				if direccion.y >0:
					pieza.play("default_frente")
				else:
					pieza.play("default_atras")
			else:
					if direccion.x > 0:
						pieza.play("default_lado")
					else:
						pieza.play("default_lado")
			print("Pieza movida a: ", nueva_pos)
			# Aquí puedes emitir una señal o llamar a una función
			# para indicar que el movimiento ha terminado
			)
		terminar_turno()
	else:
		print("Error: La pieza es null.")

func cambiar_turno():
	turnoActual += 1
	if turnoActual > totalJugadores:
		turnoActual = 1
	estado_turno = ESTADO_ESPERANDO_DADO
	print("Es el turno del Jugador ", turnoActual)

func verificar_victoria(pieza, nueva_pos):
	if nueva_pos == PosicionGanar * 15.9:
		print("¡Jugador ", turnoActual, " ha ganado con una de sus piezas!")
		# Implementar lógica adicional si es necesario

func _on_tirar_dado_pressed() -> void:
	if estado_turno != ESTADO_ESPERANDO_DADO:
		print("No es tu turno para tirar el dado.")
		return
	tirar_dado()
	var jugador = turnoActual
	print("Jugador ", jugador, " lanzó el dado: ", dado)
	if dado == 6 or tiene_piezas_en_juego(jugador):
		print("Selecciona una de tus piezas para mover.")
		estado_turno = ESTADO_ESPERANDO_PIEZA
	else:
		print("No sacaste un 6 y no tienes piezas en juego. Turno pasa al siguiente jugador.")
		terminar_turno()

func verificar_colision_con_otras_piezas(jugador_actual, posicion_index):
	var posiciones_validas_actual = obtener_posiciones_validas(jugador_actual)
	var nueva_pos = posiciones_validas_actual[posicion_index] * 15.9  # Escalar la posición
	
	for jugador_num in jugadores.keys():
		if jugador_num != jugador_actual:
			var posiciones_validas_oponente = obtener_posiciones_validas(jugador_num)
			for i in range(jugadores[jugador_num]["piezas"].size()):
				var ha_salido_oponente = jugadores[jugador_num]["han_salido"][i]
				if ha_salido_oponente:
					var posicion_index_oponente = jugadores[jugador_num]["posiciones"][i]
					var pos_oponente = posiciones_validas_oponente[posicion_index_oponente] * 15.9  # Escalar la posición
					if nueva_pos == pos_oponente:
						if not es_posicion_segura(nueva_pos):
							# Se encontró una colisión y la posición no es segura
							print("La pieza del Jugador %d ha comido la pieza del Jugador %d." % [jugador_actual, jugador_num])
							enviar_pieza_a_casa(jugador_num, i)
						else:
							print("No se puede comer en una posición segura.")

func enviar_pieza_a_casa(jugador_num, indice_pieza):
	jugadores[jugador_num]["han_salido"][indice_pieza] = false
	jugadores[jugador_num]["posiciones"][indice_pieza] = -1  # Indica que está en casa
	var pieza = jugadores[jugador_num]["piezas"][indice_pieza]
	var posicion_inicial = jugadores[jugador_num]["posiciones_iniciales"][indice_pieza]
	mover_posicion(pieza, posicion_inicial)
	print("La pieza del Jugador %d, índice %d ha sido enviada a casa." % [jugador_num, indice_pieza])

#func get_posicion_inicial_pieza(jugador_num, indice_pieza):
	#var posiciones_iniciales = []  # Declarar la variable aquí
	#match jugador_num:
		#1:
			#posiciones_iniciales = [Vector2(1,26), Vector2(4,26), Vector2(1,29), Vector2(4,29)]
		#2:
			#posiciones_iniciales = [Vector2(23,1), Vector2(26,1), Vector2(23,4), Vector2(26,4)]
		## Agrega más jugadores si es necesario
		#_:
			#posiciones_iniciales = []
	#
	#if indice_pieza >= 0 and indice_pieza < posiciones_iniciales.size():
		#return posiciones_iniciales[indice_pieza] * 15.9  # Ajusta el factor de escala si es necesario
	#else:
		#return Vector2(0, 0)  # Posición por defecto

func es_posicion_segura(posicion):
	var posiciones_seguras = [
		# Posiciones seguras aquí
		Vector2(1,23) * 15.9,
		Vector2(20,-15) * 15.9,
		Vector2(-18,17) * 15.9,
		Vector2(17,19) * 15.9,
		Vector2(1,1) * 15.9
		# Agrega más posiciones según tu juego
	]
	return posicion in posiciones_seguras
