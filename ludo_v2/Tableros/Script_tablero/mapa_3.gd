extends Node2D

#Codigo NO TERMINADO

var posiciones = [
	Vector2(560,575), Vector2(464, 575), Vector2(368, 575), Vector2(272,575), Vector2(176,575), Vector2(112, 496), Vector2(112, 416), Vector2(112, 344), Vector2(112, 272),  Vector2(112, 192), Vector2(176, 111), Vector2(272, 111),Vector2(368, 111),Vector2(464, 111),Vector2(560, 111),Vector2(656, 111),Vector2(752, 111),Vector2(848, 111),Vector2(944, 111),Vector2(1009, 192),Vector2(1009, 192),Vector2(1009, 272),Vector2(1009, 344),Vector2(1009, 416),Vector2(1009, 496),Vector2(944, 575),Vector2(848, 575),Vector2(752, 575),Vector2(656, 575),Vector2(560, 575),
	Vector2(560, 464),Vector2(560, 416),Vector2(495, 416),Vector2(432, 416),Vector2(240, 352),Vector2(240, 224), Vector2(304, 224),Vector2(432, 224),Vector2(496, 224),Vector2(560, 224),Vector2(624, 224),Vector2(688, 224),Vector2(752, 224),Vector2(816, 224),Vector2(880, 224), Vector2(880, 287), Vector2(880, 353),Vector2(880, 416), Vector2(816, 416),Vector2(752, 416), Vector2(688, 416),Vector2(624, 416),Vector2(560, 416),
	Vector2(560,348)
]
var posicionInicio=Vector2(560,600)

# Declaración de 'posiciones_seguras'
var posiciones_seguras = [
	posiciones[posiciones.size() - 1],  # La última posición de 'posiciones' es la meta
]


var punto_inicio = 0

var posicion_casas = {
	1: Vector2(560, 600),  # Posición donde las piezas del Jugador 1 comienzan
	2: Vector2(1000, 300),
	3: Vector2(560, 50),
	4: Vector2(100, 300)
}

var dado
var turnoActual = 1
var totalJugadores = 4
var jugadores = {}
var pieza_seleccionada = null
var indice_pieza_seleccionada = null
var veces_dado_igual_seis = 0
var pieza_en_movimiento = false
var ESTADO_ESPERANDO_DADO = 0
var ESTADO_ESPERANDO_PIEZA = 1
var estado_turno = ESTADO_ESPERANDO_DADO
var movimientos_pendientes = 0
var dado_sprite
var lbl_turno

@onready var sfx_plop: AudioStreamPlayer = $sfx_plop
@onready var sfx_dado: AudioStreamPlayer = $sfx_dado
@onready var sfx_fondo_jugar: AudioStreamPlayer = $sfx_fondo_jugar
@onready var sfx_wrap: AudioStreamPlayer = $sfx_wrap
@onready var sfx_jump: AudioStreamPlayer = $sfx_jump

var nombres_jugadores = {
	1: "Gato",
	2: "Sombrero",
	3: "Dinosaurio",
	4: "Oso"
}

func _ready():
	# Inicializar jugadores y sus piezas
	for jugador_num in range(1, 5):
		jugadores[jugador_num] = {
			"piezas": [],
			"posiciones": [],
			"han_salido": [],
			"posiciones_iniciales": [],
			"piezas_en_meta": []
		}
		# Configurar piezas para cada jugador
		for i in range(1, 5):
			var pieza_nombre = ""
			match jugador_num:
				1:
					pieza_nombre = "gatito" + (str(i) if i > 1 else "")
				2:
					pieza_nombre = "sombrero" + (str(i) if i > 1 else "")
				3:
					pieza_nombre = "dino" + (str(i) if i > 1 else "")
				4:
					pieza_nombre = "oso" + (str(i) if i > 1 else "")
			var pieza = get_node("%s" % pieza_nombre)
			jugadores[jugador_num]["piezas"].append(pieza)
			jugadores[jugador_num]["posiciones"].append(-1)
			jugadores[jugador_num]["han_salido"].append(false)
			jugadores[jugador_num]["posiciones_iniciales"].append(pieza.position)
			pieza.connect("piece_clicked", Callable(self, "_on_pieza_seleccionada"))
			pieza.jugador_num = jugador_num
			pieza.indice_pieza = i - 1  # Los índices comienzan desde 0

	dado_sprite = get_node("dado")
	lbl_turno = get_node("lbl_turno")
	actualizar_lbl_turno()

func _on_tirar_dado_pressed() -> void: 
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

func tirar_dado():
	dado = randi() % 6 + 1
	print("Jugador ", turnoActual, " lanzó el dado: ", dado)

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

	if jugadores[jugador]["posiciones"][indice_pieza] == -2:
		print("Esta pieza ya ha llegado a la meta.")
		return

	var ha_salido = jugadores[jugador]["han_salido"][indice_pieza]
	var posicion_index = jugadores[jugador]["posiciones"][indice_pieza]
	var old_posicion_index = posicion_index

	var total_camino = posiciones.size()

	if not ha_salido:
		if dado == 6:
			jugadores[jugador]["han_salido"][indice_pieza] = true
			posicion_index = punto_inicio
			jugadores[jugador]["posiciones"][indice_pieza] = posicion_index
			var nueva_pos = posiciones[posicion_index]
			mover_posicion(pieza_seleccionada, nueva_pos, jugador, posicion_index)
			print("La pieza ha salido de casa.")
		else:
			print("Necesitas un 6 para sacar una pieza de casa.")
			terminar_turno()
	else:
		var nueva_posicion_index = posicion_index + pasos
		if nueva_posicion_index == total_camino:
			# La pieza llega exactamente a la meta
			posicion_index = -2  # Marcamos como en meta
			jugadores[jugador]["posiciones"][indice_pieza] = posicion_index
			print("¡La pieza ha llegado a la meta!")
			verificar_victoria(pieza_seleccionada, null)
		elif nueva_posicion_index < total_camino:
			posicion_index = nueva_posicion_index
			jugadores[jugador]["posiciones"][indice_pieza] = posicion_index
			var nueva_pos = posiciones[posicion_index]
			mover_posicion(pieza_seleccionada, nueva_pos, jugador, posicion_index)
			print("Pieza movida a la posición: ", posicion_index)
			if posicion_index == total_camino - 1:
				verificar_victoria(pieza_seleccionada, nueva_pos)
		else:
			print("Movimiento no válido. Necesitas sacar un número exacto para llegar al final.")
			terminar_turno()
			return
		verificar_colision_con_otras_piezas(jugador, posicion_index)

func mover_posicion(pieza, nueva_pos, jugador, posicion_index):
	if pieza != null:
		movimientos_pendientes += 1

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
			movimientos_pendientes -= 1
			ajustar_posiciones_piezas_en_posicion(jugador, posicion_index)
			if movimientos_pendientes == 0:
				terminar_turno()
		)
	else:
		print("Error: La pieza es null.")

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
		var base_pos = posiciones_validas[posicion_index]
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

func terminar_turno():
	pieza_seleccionada = null
	indice_pieza_seleccionada = null
	estado_turno = ESTADO_ESPERANDO_DADO
	cambiar_turno()
	veces_dado_igual_seis = 0
	actualizar_lbl_turno()

func es_posicion_segura(posicion):
	return posicion in posiciones_seguras

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

func obtener_posiciones_validas(jugador):
	return posiciones


func cambiar_turno():
	turnoActual += 1
	if turnoActual > totalJugadores:
		turnoActual = 1
	print("Es el turno del Jugador ", turnoActual)

func verificar_victoria(pieza, nueva_pos):
	if nueva_pos == null or jugadores[turnoActual]["posiciones"][indice_pieza_seleccionada] == -2:
		print("¡El jugador ", turnoActual, " ha llevado una pieza a la meta!")
		jugadores[turnoActual]["piezas_en_meta"].append(pieza)
		jugadores[turnoActual]["posiciones"][indice_pieza_seleccionada] = -2
		jugadores[turnoActual]["han_salido"][indice_pieza_seleccionada] = false
		pieza.hide()
		if jugadores[turnoActual]["piezas_en_meta"].size() >= 4:
			print("¡El jugador ", turnoActual, " ha ganado el juego!")
			mostrar_mensaje_ganador(turnoActual)
			set_process(false)

func mostrar_mensaje_ganador(jugador):
	var nombre_jugador = nombres_jugadores[jugador]
	var mensaje = "¡El " + nombre_jugador + " ha ganado la partida!"
	print(mensaje)
	# Crear un Label para mostrar el mensaje
	var label_ganador = Label.new()
	label_ganador.text = mensaje
	label_ganador.set_position(Vector2(-100, 0))  # Ajusta la posición según sea necesario
	label_ganador.set_scale(Vector2(1, 1))  # Ajusta el tamaño del texto
	add_child(label_ganador)

func actualizar_lbl_turno():
	var nombre_jugador = nombres_jugadores[turnoActual]
	var texto = "Turno del " + nombre_jugador + ": "
	#mostrar_mensaje_ganador(turnoActual)
	if estado_turno == ESTADO_ESPERANDO_DADO:
		texto += "Tira el dado."
	elif estado_turno == ESTADO_ESPERANDO_PIEZA:
		texto += "Selecciona una pieza para mover."
	lbl_turno.text = texto

func verificar_colision_con_otras_piezas(jugador_actual, posicion_index):
	var nueva_pos = obtener_posicion_por_indice(jugador_actual, posicion_index)
	for jugador_num in jugadores.keys():
		for i in range(jugadores[jugador_num]["piezas"].size()):
			if jugador_num == jugador_actual and i == indice_pieza_seleccionada:
				continue  # No compararse a sí mismo
			var ha_salido_oponente = jugadores[jugador_num]["han_salido"][i]
			if ha_salido_oponente:
				var posicion_index_oponente = jugadores[jugador_num]["posiciones"][i]
				if posicion_index_oponente == -2:
					continue  # La pieza ya ha llegado a la meta
				var pos_oponente = obtener_posicion_por_indice(jugador_num, posicion_index_oponente)
				if nueva_pos == pos_oponente:
					if jugador_num == jugador_actual:
						# Es una pieza propia, ajustar posiciones para evitar superposición
						print("Dos piezas del Jugador ", jugador_actual, " están en la misma posición.")
						ajustar_posiciones_piezas_en_posicion(jugador_actual, posicion_index)
					else:
						if not es_posicion_segura(nueva_pos):
							print("La pieza del Jugador ", jugador_actual, " ha comido la pieza del Jugador ", jugador_num)
							enviar_pieza_a_casa(jugador_num, i)
						else:
							print("No se puede comer en una posición segura.")

func esta_en_meta(posicion_index, jugador):
	var total_camino = posiciones.size()
	return posicion_index >= total_camino

func obtener_posicion_por_indice(jugador, posicion_index):
	if posicion_index >= 0 and posicion_index < posiciones.size():
		return posiciones[posicion_index]
	else:
		# La pieza está en casa o ha llegado a la meta
		return null

func tiene_movimientos_validos(jugador, dado):
	var total_posiciones = posiciones.size()
	for i in range(jugadores[jugador]["piezas"].size()):
		var ha_salido = jugadores[jugador]["han_salido"][i]
		var posicion_index = jugadores[jugador]["posiciones"][i]
		if ha_salido:
			var nueva_posicion_index = posicion_index + dado
			if nueva_posicion_index <= total_posiciones:
				return true
		else:
			if dado == 6:
				return true
	return false
