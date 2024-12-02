extends Control

@onready var LineHostJ = $MarginContainer/VBoxContainer/LineEdit # Campo de texto para el nombre del jugador
@onready var LineRoomJ = $MarginContainer/VBoxContainer/LineEdit2  # Campo de texto para el código de la sala
@onready var label_textJ = $MarginContainer/VBoxContainer/Label  # Etiqueta para mostrar los mensajes
@onready var http_requestJ = $HTTPRequest  # Nodo HTTPRequest
@onready var BtnAceptarJ = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/BtnAceptarJ  # Botón para aceptar en join

func _ready() -> void:
	# Conectar las señales a los botones correspondientes
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/BtnAceptarJ.connect("pressed", Callable(self, "_on_btn_aceptar_pressed"))
	http_requestJ.connect("request_completed", Callable(self, "_on_http_request_request_completed"))

# Función cuando se presiona el botón "Aceptar" para unirse a la sala
func _on_btn_aceptar_pressed() -> void:
	if LineHostJ != null and LineRoomJ != null and label_textJ != null:
		var player_name = LineHostJ.text.strip_edges()
		var room_code = LineRoomJ.text.strip_edges()

		# Verificamos que el nombre del jugador no esté vacío
		if player_name == "":
			label_textJ.text = "Por favor ingresa tu nombre."
			return

		# Verificamos que el código de la sala no esté vacío
		if room_code == "":
			label_textJ.text = "Por favor ingresa el código de la sala."
			return

		# Crear el cuerpo de la solicitud con el formato adecuado para unirse a la sala
		var data = "action=join_room&player_name=" + player_name + "&room_code=" + room_code

		# Definir la URL de tu proxy
		var url = "http://127.0.0.1:5000/godot_action"  # Ruta en el proxy
		var headers = ["Content-Type: application/x-www-form-urlencoded"]
		
		# Realizar la solicitud HTTP POST
		var error = http_requestJ.request(url, headers, HTTPClient.METHOD_POST, data)

		# Comprobar si hubo un error al enviar la solicitud
		if error != OK:
			label_textJ.text = "Error al enviar la solicitud: " + str(error)
		else:
			label_textJ.text = "Procesando solicitud para unirse a la sala..."
	else:
		print("Uno o más nodos no están inicializados correctamente.")

# Función para manejar la respuesta del servidor
func _on_http_request_request_completed(result, response_code, headers, body) -> void:
	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		# Mostrar la respuesta del servidor (código de la sala)
		label_textJ.text = "Respuesta del servidor: " + response_text
	else:
		label_textJ.text = "Error de conexión. Código: " + str(response_code)
		
