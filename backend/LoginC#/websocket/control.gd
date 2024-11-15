extends Control

# URL del proxy
var proxy_url = "http://34.229.38.217:5000/send_message"  # Cambia a la URL de tu proxy si es necesario

# Referencias a los nodos de la escena
"@onready" var Label = $Label  # Cambia el nombre del nodo según corresponda
"@onready" var Line_host = $LineHost  # Cambia el nombre del nodo según corresponda
"@onready" var Line_room = $LineRoom  # Cambia el nombre del nodo según corresponda
"@onready" var Btn_aceptar = $BtnAceptar  # Cambia el nombre del nodo según corresponda
"@onready" var Btn_cancelar = $BtnCancelar  # Cambia el nombre del nodo según corresponda

# Llamado cuando el nodo entra en el árbol de la escena por primera vez.
func _ready() -> void:
	Btn_aceptar.connect("pressed", self, "_on_create_room_pressed")
	Btn_cancelar.connect("pressed", self, "_on_join_room_pressed")

# Función para enviar mensajes al proxy
func send_to_proxy(data: Dictionary):
	var json_data = JSON.print(data)
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	http_request.connect("request_completed", self, "_on_request_completed")
	var error = http_request.request(proxy_url, [], true, HTTPClient.METHOD_POST, json_data)
	
	if error != OK:
		print("Error al enviar la solicitud: ", error)

# Callback cuando el HTTPRequest recibe la respuesta del proxy
func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if json.error != OK:
		print("Error al parsear JSON: ", json.error_string)
	else:
		var response_data = json.result
		print("Respuesta del servidor: ", response_data)
		Label.text = "Respuesta del servidor: " + str(response_data)
		# Aquí puedes manejar la respuesta del proxy y actualizar el juego en consecuencia

# Función cuando se presiona el botón "Crear Sala"
func _on_create_room_pressed() -> void:
	var data = {
		"message": {
			"type": "create_room",
			"name": "NombreDelJugador"
		}
	}
	send_to_proxy(data)
	print("Solicitando crear sala...")

# Función cuando se presiona el botón "Unirse a Sala"
func _on_join_room_pressed() -> void:
	var room_code = Line_room.text  # Obtener el código de sala desde un input de texto
	var data = {
		"message": {
			"type": "join_room",
			"name": "NombreDelJugador",
			"room_code": room_code
		}
	}
	send_to_proxy(data)
	print("Solicitando unirse a la sala...")
