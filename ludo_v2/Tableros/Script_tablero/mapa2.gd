extends Node

var dado
var veces_dado_igual_seis = 0
var turnoActual = 1
var totalJugadores = 4
var jugadores = {}
var pieza_seleccionada = null
var indice_pieza_seleccionada = null
var pieza_en_movimiento = false
var ESTADO_ESPERANDO_DADO = 0
var ESTADO_ESPERANDO_PIEZA = 1
var estado_turno = ESTADO_ESPERANDO_DADO
var movimientos_pendientes = 0
var dado_sprite

@onready var sfx_jump: AudioStreamPlayer = $sfx_jump
@onready var sfx_plop: AudioStreamPlayer = $sfx_plop
@onready var sfx_wrap: AudioStreamPlayer = $sfx_wrap
@onready var sfx_dado: AudioStreamPlayer = $sfx_dado

#hoja turno
@onready var timer_2: Timer = $Hoja_msg_turno/Timer2
@onready var lbl_turno: Label = $Hoja_msg_turno/lbl_turno
@onready var lbl_accion: Label = $Hoja_msg_turno/lbl_accion

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

var nombres_jugadores = {
	1: "Gato",
	2: "Sombrero",
	3: "Dinosaurio",
	4: "Oso"
}

func _ready():
	$Hoja_Ganador.hide()
	
	# Obtener el nodo SpawnLocation que contiene los nodos de spawn
	var spawn_locations = get_node("SpawnLocation")
	
	# Inicializar jugadores y sus piezas
	for jugador_num in range(1, 5):
		jugadores[jugador_num] = {
			"piezas": [],
			"posiciones": [],
			"han_salido": [],
			"posiciones_iniciales": [],
			"piezas_en_meta": []
		}
	
	# Configurar piezas para cada jugador y posicionarlas en los nodos de spawn
	configurar_piezas_jugador(1, "gatito", 0, spawn_locations)
	configurar_piezas_jugador(2, "sombrero", 4, spawn_locations)
	configurar_piezas_jugador(3, "dino", 8, spawn_locations)
	configurar_piezas_jugador(4, "oso", 12, spawn_locations)
	
	dado_sprite = get_node("dado")
	dado_sprite.connect("piece_clicked", Callable(self, "_on_tirar_dado_pressed"))
	
	actualizar_lbl_turno()

# Función auxiliar para configurar las piezas de cada jugador
func configurar_piezas_jugador(jugador_num, pieza_nombre_base, spawn_start_index, spawn_locations):
	for i in range(1, 5):
		var pieza_nombre = pieza_nombre_base + (str(i) if i > 1 else "")
		var pieza = get_node("%s" % pieza_nombre)
		
		# Obtener el nodo de spawn correspondiente
		var spawn_node_index = spawn_start_index + (i - 1)
		var spawn_node = spawn_locations.get_node(str(spawn_node_index))
		pieza.position = spawn_node.position  # Asignar posición de spawn a la pieza
		
		jugadores[jugador_num]["piezas"].append(pieza)
		jugadores[jugador_num]["posiciones"].append(-1)
		jugadores[jugador_num]["han_salido"].append(false)
		jugadores[jugador_num]["posiciones_iniciales"].append(pieza.position)
		
		pieza.connect("piece_clicked", Callable(self, "_on_pieza_seleccionada"))
		pieza.jugador_num = jugador_num
		pieza.indice_pieza = i - 1

# Funcion prueba
func tiene_piezas_en_juego(jugador):
	for ha_salido in jugadores[jugador]["han_salido"]:
		if ha_salido == true:
			return true
	return false

func tirar_dado():
	dado = randi() % 6 + 1
	if dado == 6:
		veces_dado_igual_seis += 1
func _on_pieza_seleccionada(jugador_num, indice_pieza):
	if estado_turno != ESTADO_ESPERANDO_PIEZA:
		print("No puedes mover una pieza en este momento.")
		return
	if turnoActual == jugador_num:
		# Verificar si la pieza ya ha llegado a la meta
		if jugadores[jugador_num]["posiciones"][indice_pieza] == -2:
			print("Esta pieza ya ha llegado a la meta.")
			return
		var ha_salido = jugadores[jugador_num]["han_salido"][indice_pieza]
		if dado == 6 or ha_salido:
			pieza_seleccionada = jugadores[jugador_num]["piezas"][indice_pieza]
			indice_pieza_seleccionada = indice_pieza
			var nombre_jugador = nombres_jugadores[jugador_num]
			print("Pieza del " + nombre_jugador + ", índice %d seleccionada." % indice_pieza)
			mover_pieza(dado)
			actualizar_lbl_turno()  # Actualizar el label si es necesario
		else:
			print("No puedes mover esta pieza porque no ha salido y no sacaste un 6.")
	else:
		var nombre_jugador_actual = nombres_jugadores[turnoActual]
		print("No es tu turno. Es el turno del " + nombre_jugador_actual + ".")

func mover_pieza(pasos):
	if pieza_seleccionada == null:
		print("Debes seleccionar una pieza para mover.")
		return

	var jugador = turnoActual
	var indice_pieza = indice_pieza_seleccionada

	# Verificar si la pieza ya ha llegado a la meta
	if jugadores[jugador]["posiciones"][indice_pieza] == -2:
		print("Esta pieza ya ha llegado a la meta.")
		return

	var posiciones_validas = obtener_posiciones_validas(jugador)
	var posicion_index = jugadores[jugador]["posiciones"][indice_pieza]
	var ha_salido = jugadores[jugador]["han_salido"][indice_pieza]
	var old_posicion_index = posicion_index  # Guardar la posición anterior

	if not ha_salido:
		jugadores[jugador]["han_salido"][indice_pieza] = true
		posicion_index = 0
		jugadores[jugador]["posiciones"][indice_pieza] = posicion_index
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
		3:
			return posicionValidaJ3
		4:
			return posicionValidaJ4
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
		tween.tween_property(pieza, "position", nueva_pos, 1)
		sfx_jump.play()

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
	sfx_plop.play()
	var nombre_jugador = nombres_jugadores[turnoActual]
	print("Es el turno del " + nombre_jugador)
	actualizar_lbl_turno()

func terminar_turno():
	pieza_seleccionada = null
	indice_pieza_seleccionada = null
	estado_turno = ESTADO_ESPERANDO_DADO
	cambiar_turno()
	veces_dado_igual_seis = 0
	actualizar_lbl_turno()

func verificar_victoria(pieza, nueva_pos):
	if nueva_pos == PosicionGanar * 15.9:
		var nombre_jugador = nombres_jugadores[turnoActual]
		print("¡El " + nombre_jugador + " ha llevado una pieza a la meta!")
		# Reproducir la animación transportar_frente
		pieza.play("transportar_frente")
		sfx_wrap.play()
		# Esperar un tiempo fijo (por ejemplo, 1.06 segundos)
		$Timer.wait_time = 1.5
		$Timer.start()
		await $Timer.timeout
		# Hacer que la pieza desaparezca
		pieza.hide()
		# Marcar la pieza como ganadora
		var jugador = turnoActual
		var indice_pieza = indice_pieza_seleccionada
		jugadores[jugador]["piezas_en_meta"].append(pieza)
		# Actualizar el estado de la pieza
		jugadores[jugador]["han_salido"][indice_pieza] = false
		jugadores[jugador]["posiciones"][indice_pieza] = -2  # Indica que está en la meta
		# Verificar si el jugador ha ganado el juego
		if jugadores[jugador]["piezas_en_meta"].size() >= 4:
			print("¡El " + nombre_jugador + " ha ganado el juego!")
			mostrar_mensaje_ganador(jugador)
			# Implementar lógica para finalizar el juego, por ejemplo, detener la entrada
			set_process(false)

func mostrar_mensaje_ganador(jugador):
	$Hoja_Ganador.show()
	$Hoja_Ganador/timer_ganar.start()
	
	var nombre_jugador = nombres_jugadores[jugador]
	var mensaje = "¡el " + nombre_jugador + " ha ganado!"
	
	$Hoja_Ganador/lbl_Ganador/lbl_Ganador_sadow.text = mensaje;
	$Hoja_Ganador/lbl_Ganador.text = mensaje;

func _on_tirar_dado_pressed(indice_pieza) -> void:
	if estado_turno != ESTADO_ESPERANDO_DADO:
		print("No es tu turno para tirar el dado.")
		return
	# Generar el número aleatorio
	tirar_dado()
	# Determinar la animación correspondiente
	var animacion_numero = ""
	match dado:
		1:
			animacion_numero = "uno"
		2:
			animacion_numero = "dos"
		3:
			animacion_numero = "tres"
		4:
			animacion_numero = "cuatro"
		5:
			animacion_numero = "cinco"
		6:
			animacion_numero = "seis"
		_:
			print("Error: Número de dado inválido.")

	# Reproducir la animación correspondiente
	if animacion_numero != "":
		dado_sprite.play(animacion_numero)
		sfx_dado.play()
		$Timer.wait_time = 1.06
		$Timer.start()
		await $Timer.timeout
	else:
		print("Error al reproducir la animación del dado.")

	# Opción 1: Continuar la lógica inmediatamente
	continuar_logica_del_juego()

func continuar_logica_del_juego():
	var jugador = turnoActual
	print("Jugador ", jugador, " lanzó el dado: ", dado)
	if tiene_movimientos_validos(jugador, dado):
		print("Selecciona una de tus piezas para mover.")
		estado_turno = ESTADO_ESPERANDO_PIEZA
	else:
		print("No tienes movimientos válidos. Turno pasa al siguiente jugador.")
		terminar_turno()
	actualizar_lbl_turno()

func verificar_colision_con_otras_piezas(jugador_actual, posicion_index):
	var posiciones_validas_actual = obtener_posiciones_validas(jugador_actual)
	var nueva_pos = posiciones_validas_actual[posicion_index] * 15.9
	for jugador_num in jugadores.keys():
		if jugador_num != jugador_actual:
			var posiciones_validas_oponente = obtener_posiciones_validas(jugador_num)
			for i in range(jugadores[jugador_num]["piezas"].size()):
				var ha_salido_oponente = jugadores[jugador_num]["han_salido"][i]
				if ha_salido_oponente:
					var posicion_index_oponente = jugadores[jugador_num]["posiciones"][i]
					var pos_oponente = posiciones_validas_oponente[posicion_index_oponente] * 15.9
					if nueva_pos == pos_oponente:
						if not es_posicion_segura(nueva_pos):
							var nombre_jugador_actual = nombres_jugadores[jugador_actual]
							var nombre_oponente = nombres_jugadores[jugador_num]
							print("La pieza del " + nombre_jugador_actual + " ha comido la pieza del " + nombre_oponente + ".")
							enviar_pieza_a_casa(jugador_num, i)
						else:
							print("No se puede comer en una posición segura.")

# Modificación aquí: Reemplazar mover_posicion por transportar_pieza_a_casa
func enviar_pieza_a_casa(jugador_num, indice_pieza):
	var old_posicion_index = jugadores[jugador_num]["posiciones"][indice_pieza]
	jugadores[jugador_num]["han_salido"][indice_pieza] = false
	jugadores[jugador_num]["posiciones"][indice_pieza] = -1  # Indica que está en casa
	var pieza = jugadores[jugador_num]["piezas"][indice_pieza]
	var posicion_inicial = jugadores[jugador_num]["posiciones_iniciales"][indice_pieza]
	# Llamar a la nueva función en lugar de mover_posicion
	transportar_pieza_a_casa(pieza, posicion_inicial, jugador_num, old_posicion_index)
	$Timer.wait_time = 1.5
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
		sfx_wrap.play()
		# Wait for the animation to finish
		$Timer.wait_time = 1.5
		$Timer.start()
		await $Timer.timeout
		pieza.position = posicion_inicial
		# Play "default_frente" animation after moving
		pieza.play("transportar_frente_r")
		sfx_wrap.play()
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
			var radius = 21  # Ajusta el radio según sea necesario
			for idx in range(num_piezas):
				var angle = idx * angle_step
				var offset = Vector2(radius * cos(angle), radius * sin(angle))
				var target_position = base_pos + offset
				var tween = create_tween()
				tween.tween_property(piezas_en_posicion[idx], "position", target_position, 0.5)

func _on_timer_timeout() -> void:
	print("Termino")

func actualizar_lbl_turno():
	$Hoja_msg_turno.show()
	timer_2.start()
	var nombre_jugador = nombres_jugadores[turnoActual]
	lbl_turno.text = "turno del " + nombre_jugador.to_upper()
	#mostrar_mensaje_ganador(turnoActual)
	if estado_turno == ESTADO_ESPERANDO_DADO:
		lbl_accion.text = "Toca el dado."
	elif estado_turno == ESTADO_ESPERANDO_PIEZA:
		lbl_accion.text =  "Selecciona una pieza."

func tiene_movimientos_validos(jugador, dado):
	for i in range(jugadores[jugador]["piezas"].size()):
		var ha_salido = jugadores[jugador]["han_salido"][i]
		var posicion_index = jugadores[jugador]["posiciones"][i]
		var posiciones_validas = obtener_posiciones_validas(jugador)
		if ha_salido:
			# La pieza está en juego
			if posicion_index + dado < posiciones_validas.size():
				# La pieza puede moverse dentro del tablero
				return true
		else:
			# La pieza está en casa
			if dado == 6:
				# Puede salir de casa
				return true
	# Si ninguna pieza puede moverse, retorna false
	return false


func _on_window_close_requested() -> void:
	pass # Replace with function body.

func _on_timer_2_timeout() -> void:
	$Hoja_msg_turno.hide()
	
func _on_timer_ganar_timeout() -> void:
	$Hoja_Ganador.hide()
