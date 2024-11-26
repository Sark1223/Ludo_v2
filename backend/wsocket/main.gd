extends Node

# Referencias a los nodos de la escena con los nombres que mencionaste
@onready var player_name_input = $L_Nombre      # LineEdit para ingresar el nombre del jugador
@onready var room_code_input = $RoomCodeInput   # Este sigue siendo el mismo, ajusta el nombre si es diferente
@onready var create_room_button = $Crear_S      # Botón para crear la sala
@onready var join_room_button = $Unirme_S       # Botón para unirse a la sala
@onready var chat_input = $ChatInput            # Este sigue siendo el mismo, ajusta si es necesario
@onready var send_chat_button = $SendChatButton # Este sigue siendo el mismo, ajusta si es necesario

var main_script : Node = null

# Al iniciar la escena, conseguimos la referencia al script C# (Main.cs)
func _ready():
	main_script = get_node("/root/Main")  # Asegúrate de que esta ruta sea correcta
	

# Función para crear una sala
func _on_create_room_button_pressed():
	var player_name = player_name_input.text
	if player_name.empty():
		print("Por favor ingresa tu nombre.")
		return
	
	# Llamar a la función en Main.cs para crear la sala
	main_script.CreateRoom(player_name)

# Función para unirse a una sala
func _on_join_room_button_pressed():
	var player_name = player_name_input.text
	var room_code = room_code_input.text
	if player_name.empty() or room_code.empty():
		print("Por favor ingresa tu nombre y el código de la sala.")
		return
	
	# Llamar a la función en Main.cs para unirse a la sala
	main_script.JoinRoom(room_code, player_name)

# Función para enviar un mensaje de chat
func _on_send_chat_button_pressed():
	var player_name = player_name_input.text
	var room_code = room_code_input.text
	var message = chat_input.text
	if player_name.empty() or room_code.empty() or message.empty():
		print("Por favor completa todos los campos.")
		return
	
	# Llamar a la función en Main.cs para enviar un mensaje de chat
	main_script.SendChatMessage(room_code, player_name, message)
