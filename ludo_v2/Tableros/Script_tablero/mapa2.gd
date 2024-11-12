extends Node

var dado
var veces_dado_igual_seis = 0 
var turnoActual = 1
var totalJugadores = 2
var jugadores = {}
var pieza_seleccionada = null
var indice_pieza_seleccionada = null
var pieza_en_movimiento = false
var ESTADO_ESPERANDO_DADO = 0
var ESTADO_ESPERANDO_PIEZA = 1
var estado_turno = ESTADO_ESPERANDO_DADO
var movimientos_pendientes = 0

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
		else:
			print("No puedes mover esta pieza porque no ha salido y no sacaste un 6.")
	else:
		print("No es tu turno. Es el turno del Jugador %d." % turnoActual)

func mover_pieza(pasos):
	if pieza_seleccionada == null:
		print("Debes seleccionar una pieza para mover.")
		return

	var jugador = turnoActual
	var indice_pieza = indice_pieza_seleccionada
	var posiciones_validas = obtener_posiciones_validas(jugador)
	var posicion_index = jugadores[jugador]["posiciones"][indice_pieza]
	var ha_salido = jugadores[jugador]["han_salido"][indice_pieza]
	var old_posicion_index = posicion_index  # Guardar la posición anterior

	if not ha_salido:
		jugadores[jugador]["han_salido"][indice_pieza] = true
		posicion_index = 0
		jugadores[jugador]["posiciones"][indice_pieza] = posicion_index
		# Ajustar las posiciones en casa antes de que la pieza salga
		#ajustar_posiciones_piezas_en_posicion(jugador, -1)
		var nueva_pos = posicionInicio[jugador - 1] * 15.9
		mover_posicion(pieza_seleccionada, nueva_pos, jugador, posicion_index)
		print("La pieza ha salido de casa.")
	else:
		if posicion_index + pasos < posiciones_validas.size():
			posicion_index += pasos
			# Ajustar las posiciones en la posición antigua antes de mover la pieza
			ajustar_posiciones_piezas_en_posicion(jugador, old_posicion_index)
			jugadores[jugador]["posiciones"][indice_pieza] = posicion_index
			var nueva_pos = posiciones_validas[posicion_index] * 15.9
			mover_posicion(pieza_seleccionada, nueva_pos, jugador, posicion_index)
			print("Pieza movida a la posición: ", posicion_index)
			verificar_victoria(pieza_seleccionada, nueva_pos)
			verificar_colision_con_otras_piezas(jugador, posicion_index)
		else:
			print("No puedes moverte fuera del tablero.")

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

func mover_posicion(pieza, nueva_pos, jugador, posicion_index):
	if pieza != null:
		movimientos_pendientes += 1  # Incrementar al iniciar el movimiento

		var pos_inicial = pieza.position
		var direccion = nueva_pos - pos_inicial

		# Reproducir animación según dirección
		if abs(direccion.y) > abs(direccion.x):
			if direccion.y > 0:
				pieza.play("salto_frente")
			else:
				pieza.play("salto_atras")
		else:
			if direccion.x > 0:
				pieza.play("salto_lado")
			else:
				pieza.play("salto_lado_izq")
		
		var tween = create_tween()
		tween.tween_property(pieza, "position", nueva_pos, 2)
		
		tween.finished.connect(func():
			# Reproducir animación default
			if abs(direccion.y) > abs(direccion.x):
				if direccion.y > 0:
					pieza.play("default_frente")
				else:
					pieza.play("default_atras")
			else:
				if direccion.x > 0:
					pieza.play("default_lado")
				else:
					pieza.play("default_lado_izq")
					
			print("Pieza movida a: ", nueva_pos)
			movimientos_pendientes -= 1  # Decrementar al terminar el movimiento
			ajustar_posiciones_piezas_en_posicion(jugador, posicion_index)
			if movimientos_pendientes == 0:
				terminar_turno()
		)
	else:
		print("Error: La pieza es null.")

func cambiar_turno():
	turnoActual += 1
	if turnoActual > totalJugadores:
		turnoActual = 1
	estado_turno = ESTADO_ESPERANDO_DADO
	print("Es el turno del Jugador ", turnoActual)

func terminar_turno():
	pieza_seleccionada = null
	indice_pieza_seleccionada = null
	estado_turno = ESTADO_ESPERANDO_DADO
	cambiar_turno()
	veces_dado_igual_seis = 0

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

# Modificación aquí: Reemplazar mover_posicion por transportar_pieza_a_casa
func enviar_pieza_a_casa(jugador_num, indice_pieza):
	var old_posicion_index = jugadores[jugador_num]["posiciones"][indice_pieza]
	jugadores[jugador_num]["han_salido"][indice_pieza] = false
	jugadores[jugador_num]["posiciones"][indice_pieza] = -1  # Indica que está en casa
	var pieza = jugadores[jugador_num]["piezas"][indice_pieza]
	# Ajustar las posiciones en la posición antigua antes de mover la pieza
	#ajustar_posiciones_piezas_en_posicion(jugador_num, old_posicion_index)
	var posicion_inicial = jugadores[jugador_num]["posiciones_iniciales"][indice_pieza]
	# Llamar a la nueva función en lugar de mover_posicion
	transportar_pieza_a_casa(pieza, posicion_inicial, jugador_num, old_posicion_index)
	$Timer.start()
	await $Timer.timeout
	print("La pieza del Jugador %d, índice %d ha sido enviada a casa." % [jugador_num, indice_pieza])
	# Ajustar las posiciones en casa después de que la pieza llegue
	ajustar_posiciones_piezas_en_posicion(jugador_num, -1)

# Nueva función: transportar_pieza_a_casa
func transportar_pieza_a_casa(pieza, posicion_inicial, jugador_num, old_posicion_index):
	if pieza != null:
		movimientos_pendientes += 1
		pieza.play("transportar_frente")
		# Wait for the animation to finish
		$Timer.start()
		await $Timer.timeout
		# Step 2: Move the piece to its initial position (home)
		pieza.position = posicion_inicial
		#$Timer.start()
		#await $Timer.timeout
		# Play "default_frente" animation after moving
		pieza.play("transportar_frente_r")
		movimientos_pendientes -= 1  # Decrement after finishing
		# Now adjust positions at the old position
		ajustar_posiciones_piezas_en_posicion(jugador_num, old_posicion_index)
		if movimientos_pendientes == 0:
			terminar_turno()
	else:
		print("Error: La pieza es null.")

func es_posicion_segura(posicion):
	var posiciones_seguras = [
		# Posiciones seguras aquí
		#Vector2(1,23) * 15.9,
		#Vector2(20,-15) * 15.9,
		#Vector2(-18,17) * 15.9,
		#Vector2(17,19) * 15.9,
		Vector2(1,1) * 15.9
	]
	return posicion in posiciones_seguras

func ajustar_posiciones_piezas_en_posicion(jugador_num, posicion_index):
	if posicion_index == -1:
		# Ajustar las posiciones de las piezas en casa
		var piezas_en_casa = []
		for i in range(jugadores[jugador_num]["piezas"].size()):
			if jugadores[jugador_num]["posiciones"][i] == -1:
				piezas_en_casa.append(jugadores[jugador_num]["piezas"][i])
		if piezas_en_casa.size() == 0:
			return
		var base_positions = []
		for pieza in piezas_en_casa:
			var indice_pieza = jugadores[jugador_num]["piezas"].find(pieza)
			var base_pos = jugadores[jugador_num]["posiciones_iniciales"][indice_pieza]
			base_positions.append(base_pos)
		# Ajustar las posiciones ligeramente alrededor de sus posiciones base
		var num_piezas = piezas_en_casa.size()
		
		if num_piezas == 1:
			# Solo una pieza, mover a la posición base sin desplazamiento
			var target_position = base_positions[0]
			var tween = create_tween()
			tween.tween_property(piezas_en_casa[0], "position", target_position, 0.5)
		else:
			# Ajustar las posiciones ligeramente alrededor de sus posiciones base
			var angle_step = 2 * PI / num_piezas
			var radius = 16  # Ajusta el radio según sea necesario
			for idx in range(num_piezas):
				var angle = idx * angle_step
				var offset = Vector2(radius * cos(angle), radius * sin(angle))
				var target_position = base_positions[idx] + offset
				var tween = create_tween()
				tween.tween_property(piezas_en_casa[idx], "position", target_position, 0.5)
	else:
		var piezas_en_posicion = []
		for i in range(jugadores[jugador_num]["piezas"].size()):
			if jugadores[jugador_num]["posiciones"][i] == posicion_index:
				piezas_en_posicion.append(jugadores[jugador_num]["piezas"][i])
		if piezas_en_posicion.size() == 0:
			return
		var posiciones_validas = obtener_posiciones_validas(jugador_num)
		var base_pos = posiciones_validas[posicion_index] * 15.9
		var num_piezas = piezas_en_posicion.size()
		
		if num_piezas == 1:
			# Solo una pieza, mover a la posición base sin desplazamiento
			var target_position = base_pos
			var tween = create_tween()
			tween.tween_property(piezas_en_posicion[0], "position", target_position, 0.5)
		else:
			# Ajustar las posiciones en el tablero cuando hay múltiples piezas
			var angle_step = 2 * PI / num_piezas
			var radius = 16  # Ajusta el radio según sea necesario
			for idx in range(num_piezas):
				var angle = idx * angle_step
				var offset = Vector2(radius * cos(angle), radius * sin(angle))
				var target_position = base_pos + offset
				var tween = create_tween()
				tween.tween_property(piezas_en_posicion[idx], "position", target_position, 0.5)

func _on_timer_timeout() -> void:
	print("Termino")
