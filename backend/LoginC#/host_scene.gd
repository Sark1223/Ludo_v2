extends Control
@onready var BtnAceptarH = $MarginContainer/VBoxContainer/HBoxContainer/BtnAceptarH  # Botón para aceptar en el host

@onready var LineHost = $MarginContainer/VBoxContainer/LineHost
@onready var label_text = $MarginContainer/VBoxContainer/label_text
@onready var http_request = $HTTPRequest  # Nodo HTTPRequest

func _ready() -> void:
	# Conectar señales
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/BtnAceptarH.connect("pressed", Callable(self, "_on_btn_aceptar_pressed"))
	http_request.connect("request_completed", Callable(self, "_on_http_request_request_completed"))

func _on_btn_aceptar_pressed() -> void:
	var player_name = LineHost.text.strip_edges()
	if player_name == "":
		label_text.text = "Por favor ingresa tu nombre."
		return

	# Crear el cuerpo de la solicitud con formato simple
	var data = "action=create_room&player_name=" + player_name

	var url = "http://127.0.0.1:5000/godot_action"  # Nueva ruta en el proxy
	var headers = ["Content-Type: application/x-www-form-urlencoded"]
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, data)

	if error != OK:
		label_text.text = "Error al enviar la solicitud: " + str(error)
	else:
		label_text.text = "Procesando solicitud..."

func _on_http_request_request_completed(result, response_code, headers, body) -> void:
	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		# Solo mostramos la respuesta tal cual la envíe el proxy (como texto)
		label_text.text = "Código de la sala: " + response_text
	else:
		label_text.text = "Error de conexión. Código: " + str(response_code)
