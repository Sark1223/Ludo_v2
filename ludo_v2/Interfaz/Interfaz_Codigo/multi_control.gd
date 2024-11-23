extends Control

@export var Address = "127.0.0.1"
@export var port = 8910
var peer

var monkey: String = "res://Personajes/Escenas_personajes/mono.tscn"
var cat: String = "res://Personajes/Escenas_personajes/gatito.tscn"
var hat: String = "res://Personajes/Escenas_personajes/sombrero.tscn"
var level_1: String = "res://Tableros/Escenas_tablero/mapa_1_1.tscn"
var level_2: String = "res://Tableros/Escenas_tablero/mapa_2.tscn"
var sceneSelect: String = ""

# var GameManager = preload("res://Interfaz/Interfaz_Codigo/GameManager.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

# this get called on the server and clients
func peer_connected(id):
	print("Player Connected " + str(id))
	
# this get called on the server and clients
func peer_disconnected(id):
	print("Player Disconnected " + str(id))

# called only from clients
func connected_to_server():
	print("connected To Sever!")
	SendPlayerInformation.rpc_id(1,$txt_nombreUsuario.text, multiplayer.get_unique_id())

@rpc("any_peer")
func SendPlayerInformation(name, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] ={
			"name" : name,
			"id" : id,
			"score": 0
		}
	
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[i].name, i)

# called only from clients
func connection_failed():
	print("Couldnt Connect")



func change_scene():
	get_tree().change_scene_to_file(global_var.sceneSelect)
	
@rpc("any_peer","call_local")	
func StartGame():
	#var scene = load("res://Tableros/Escenas_tablero/mapa_2.tscn").instantiate()
	#get_tree().root.add_child(scene)
	change_scene()
	self.hide()

func _on_host_button_down():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 4)
	
	if error != OK:
		print("cannot host: " + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Esperando")
	SendPlayerInformation($txt_nombreUsuario.text, multiplayer.get_unique_id())
	


func _on_join_button_down() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)

func _on_empezar_button_down() -> void:
	StartGame.rpc()
	pass

func _on_campos_pressed() -> void:
	global_var.sceneSelect = level_1
	print("Se eligio el escenario del campo")


func _on_puerto_pressed() -> void:
	global_var.sceneSelect = level_2
	print("Se eligio el escenario del puerto")


func _on_btn_chango_pressed() -> void:
	global_var.playerChar = monkey
	print("Se eligio el personaje chango")


func _on_btn_sombrero_pressed() -> void:
	global_var.playerChar = hat
	print("Se eligio el personaje sombrero")


func _on_btn_gato_pressed() -> void:
	global_var.playerChar = cat
	print("Se eligio el personaje gato")
