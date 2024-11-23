extends Node2D


var dado
var veces_dado_igual_seis = 0
var turnoActual = 1
var totalJugadores = 3
var jugadores = {}
var pieza_seleccionada = null
var indice_pieza_seleccionada = null
var pieza_en_movimiento = false
var ESTADO_ESPERANDO_DADO = 0
var ESTADO_ESPERANDO_PIEZA = 1
var estado_turno = ESTADO_ESPERANDO_DADO
var movimientos_pendientes = 0
var dado_sprite
var lbl_turno

#Audio
@onready var sfx_jump: AudioStreamPlayer = $sfx_jump
@onready var sfx_plop: AudioStreamPlayer = $sfx_plop
@onready var sfx_wrap: AudioStreamPlayer = $sfx_wrap
@onready var sfx_dado: AudioStreamPlayer = $sfx_dado

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
var posicionesGanar = [Vector2(0, 4), Vector2(1, 1), Vector2(0, 2), Vector2(-1,2)]
	
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

var nombres_jugadores = {
	1: "Gato",
	2: "Sombrero",
	3: "Dinosaurio"
}

func _on_ready() -> void:
	# Inicializar jugadores y sus piezas
	jugadores[1] = {
		"piezas": [],
		"posiciones": [],
		"han_salido": [],
		"posiciones_iniciales": [],
		"piezas_en_meta": []
	}
	jugadores[2] = {
		"piezas": [],
		"posiciones": [],
		"han_salido": [],
		"posiciones_iniciales": [],
		"piezas_en_meta": []
	}
	jugadores[3] = {
		"piezas": [],
		"posiciones": [],
		"han_salido": [],
		"posiciones_iniciales": [],
		"piezas_en_meta": []
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

	# Configurar piezas del Jugador 3 (dino)
	for i in range(1, 5):
		var pieza_nombre = "dino" + (str(i) if i > 1 else "")
		var pieza = get_node("%s" % pieza_nombre)
		jugadores[3]["piezas"].append(pieza)
		jugadores[3]["posiciones"].append(-1)
		jugadores[3]["han_salido"].append(false)
		jugadores[3]["posiciones_iniciales"].append(pieza.position)
		pieza.connect("piece_clicked", Callable(self, "_on_pieza_seleccionada"))
		#Asignar jugador_num e indice_pieza a la pieza
		pieza.jugador_num = 3
		pieza.indice_pieza = i - 1 # Los indices comienzan con 0
		
	dado_sprite = get_node("dado")
	# Obtener el nodo lbl_turno (ajusta la ruta si es necesario)
	lbl_turno = get_node("lbl_turno")
	# Actualizar el label al iniciar el juego
	actualizar_lbl_turno() # Replace with function body.
	
	
func actualizar_lbl_turno():
	var nombre_jugador = nombres_jugadores[turnoActual]
	var texto = "Turno del " + nombre_jugador + ": "
	#mostrar_mensaje_ganador(turnoActual)
	if estado_turno == ESTADO_ESPERANDO_DADO:
		texto += "Tira el dado."
	elif estado_turno == ESTADO_ESPERANDO_PIEZA:
		texto += "Selecciona una pieza para mover."
	lbl_turno.text = texto
	
# Funcion prueba
func tiene_piezas_en_juego(jugador):
	for ha_salido in jugadores[jugador]["han_salido"]:
		if ha_salido == true:
			return true
	return false

#funcion tirar dado
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
		

func obtener_posiciones_validas(jugador):
	match jugador:
		1:
			return posicionesValidasP1
		2:
			return posicionesValidasP2
		3:
			return posicionesValidasP3
		_:
			return []

func mover_pieza(pasos):
	#Verificar si ya se selecciono pieza
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
		var nueva_pos = posicionesInicio[jugador - 1] * 15.9
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

func verificar_victoria(pieza, posFinal):
	var PosicionGanar = posicionesGanar[turnoActual - 1] * 15.9
	if posFinal == PosicionGanar:
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
	var nombre_jugador = nombres_jugadores[jugador]
	var mensaje = "¡El " + nombre_jugador + " ha ganado la partida!"
	print(mensaje)
	# Crear un Label para mostrar el mensaje
	var label_ganador = Label.new()
	label_ganador.text = mensaje
	label_ganador.set_position(Vector2(-100, 0))  # Ajusta la posición según sea necesario
	label_ganador.set_scale(Vector2(1, 1))  # Ajusta el tamaño del texto
	add_child(label_ganador)

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
