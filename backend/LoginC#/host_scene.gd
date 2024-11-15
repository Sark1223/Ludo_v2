extends Control

# URL del proxy
var proxy_url = "http://127.0.0.1:5000/send_message"  # Cambia a la URL de tu proxy si es necesario

# Referencias a los nodos de la escena
@onready var label_text = $Label  # Cambié el nombre a 'label_text'
@onready var LineHost = $LineHost  # Campo de texto para el nombre del jugador
@onready var LineRoom = $LineRoom  # Campo de texto para el código de la sala
@onready var BtnAceptar = $BtnAceptar  # Botón para aceptar (crear sala o unirse)
@onready var BtnCancelar = $BtnCancelar  # Botón para cancelar (no usado en este caso)

# Llamado cuando el nodo entra en el árbol de la escena por primera vez.
func _ready() -> void:
	# Conectar el botón "Aceptar" a la función de manejo
	BtnAceptar.connect("pressed", self, "_on_btn_aceptar_pressed")

# Función para enviar mensajes al proxy
func send_to_proxy(data: Dictionary):
	var json_instance = JSON.new()  # Crear instancia de JSON
	var json_data = json_instance.print(data)  # Serializar el diccionario a JSON
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	http_request.connect("request_completed", self, "_on_request_completed")
	var error = http_request.request(proxy_url, [], true, HTTPClient.METHOD_POST, json_data)
	
	if error != OK:
		print("Error al enviar la solicitud: ", error)

# Callback cuando el HTTPRequest recibe la respuesta del proxy
func _on_request_completed(result, response_code, headers, body):
	var json_instance = JSON.new()
	var parse_result = json_instance.parse(body.get_string_from_utf8())
	if parse_result != OK:
		print("Error al parsear JSON: ", json_instance.error_string)
	else:
		var response_data = json_instance.result
		print("Respuesta del servidor: ", response_data)
		label_text.text = "Respuesta del servidor: " + str(response_data)

# Función cuando se presiona el botón "Aceptar"
func _on_btn_aceptar_pressed() -> void:
	# Obtener el nombre del jugador desde LineHost
	var player_name = LineHost.text.strip_edges()  # Elimina espacios al principio y al final

	# Verificamos si el nombre está vacío
	if player_name == "":
		label_text.text = "Por favor ingresa tu nombre."
		return
	
	# Verificamos si el campo LineRoom (código de sala) está vacío
	var room_code = LineRoom.text.strip_edges()
	if room_code == "":
		# Si el campo LineRoom está vacío, creamos una nueva sala
		var data = {
			"message": {
				"type": "create_room",
				"name": player_name
			}
		}
		send_to_proxy(data)
		print("Solicitando crear sala con el nombre de jugador: ", player_name)
		label_text.text = "Solicitando crear sala..."
	else:
		# Si el campo LineRoom tiene un código, intentamos unirse a la sala
		if room_code == "":
			label_text.text = "Por favor ingresa el código de la sala."
			return
		
		var data = {
			"message": {
				"type": "join_room",
				"name": player_name,
				"room_code": room_code
			}
		}
		send_to_proxy(data)
		print("Solicitando unirse a la sala con el código: ", room_code, " y el nombre de jugador: ", player_name)
		label_text.text = "Solicitando unirse a la sala..."
