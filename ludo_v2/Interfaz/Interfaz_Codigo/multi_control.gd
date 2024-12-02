extends Control

@export var Address = "127.0.0.1"
@export var port = 8910
var peer

var monkey: String = "res://Personajes/Escenas_personajes/mono.tscn"
var cat: String = "res://Personajes/Escenas_personajes/gatito.tscn"
var hat: String = "res://Personajes/Escenas_personajes/sombrero.tscn"
var level_1: String = "res://Tableros/Escenas_tablero/mapa_1_1.tscn"
var level_2: String = "res://Tableros/Escenas_tablero/mapa_2.tscn"
var level_3: String = "res://Tableros/Escenas_tablero/Mapa_3.tscn"
var sceneSelect: String = ""
@onready var lblmapa_select: Label = $lblmapaSelect

var players = {}  # Estructura para manejar jugadores conectados

func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

# Evento cuando un jugador se conecta
func peer_connected(id):
	print("Jugador conectado: " + str(id))

# Evento cuando un jugador se desconecta
func peer_disconnected(id):
	if players.has(id):
		players.erase(id)
		print("Jugador desconectado: " + str(id))

# Evento para los clientes cuando se conectan al servidor
func connected_to_server():
	print("Conectado al servidor")
	SendPlayerInformation.rpc_id(1, $txt_nombreUsuario.text, multiplayer.get_unique_id())

@rpc("any_peer")
func SendPlayerInformation(name, id):
	if !players.has(id):
		players[id] = {
			"name": name,
			"id": id,
			"score": 0
		}
	print("Información de jugador recibida: " + name)
	if multiplayer.is_server():
		# Sincronizar jugadores existentes
		for player_id in players:
			SendPlayerInformation.rpc(players[player_id].name, player_id)

# Evento cuando falla la conexión
func connection_failed():
	print("No se pudo conectar al servidor.")

# Cambiar escena seleccionada
func change_scene():
	get_tree().change_scene_to_file(sceneSelect)

@rpc("any_peer", "call_local")
func StartGame():
	change_scene()
	self.hide()

# Configurar como host
func _on_host_button_down():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 4)

	if error != OK:
		print("No se pudo iniciar el servidor: " + str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	print("Servidor iniciado. Esperando jugadores...")
	SendPlayerInformation($txt_nombreUsuario.text, multiplayer.get_unique_id())

# Unirse como cliente
func _on_join_button_down():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(Address, port)

	if error != OK:
		print("No se pudo conectar al servidor: " + str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	print("Conectando al servidor...")

# Iniciar juego (puede ser usado por cualquier par conectado)
func _on_empezar_button_down():
	StartGame.rpc()

# Selección de nivel
func _on_campos_pressed():
	sceneSelect = level_1
	lblmapa_select.text = "Seleccionaste: Campo"
	print("Escenario seleccionado: Campo")

func _on_puerto_pressed():
	sceneSelect = level_2
	lblmapa_select.text = "Seleccionaste: Puerto"
	print("Escenario seleccionado: Puerto")

func _on_lavas_pressed():
	sceneSelect = level_3
	lblmapa_select.text = "Seleccionaste: Lava"
	print("Escenario seleccionado: Lava")

# Selección de personaje
func _on_btn_chango_pressed():
	global_var.playerChar = monkey
	print("Personaje seleccionado: Chango")

func _on_btn_sombrero_pressed():
	global_var.playerChar = hat
	print("Personaje seleccionado: Sombrero")

func _on_btn_gato_pressed():
	global_var.playerChar = cat
	print("Personaje seleccionado: Gato")
