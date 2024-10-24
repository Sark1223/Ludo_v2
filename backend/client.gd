extends Node

var http_request : HTTPRequest

func _ready():
	# Inicializa HTTPRequest node
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_on_request_completed")

	# Prepara la URL del proxy Flask
	var url = "http://127.0.0.1:5000/send_message"  # Cambia a la URL de tu proxy si está en otro host

	# El mensaje que se enviará al proxy Flask
	var message = {
		"message": "Estoy bien cabron"
	}

	# Convierte el mensaje a JSON
	var json_message = JSON.print(message)

	# Realiza la petición POST al proxy Flask
	var headers = ["Content-Type: application/json"]
	var result = http_request.request(url, headers, false, HTTPClient.METHOD_POST, json_message)

	if result != OK:
		print("Error al hacer la petición: ", result)

# Maneja la respuesta cuando se completa la petición HTTP
func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var response_json = JSON.parse(body.get_string_from_utf8())
		if response_json.error == OK:
			var response = response_json.result
			print("Respuesta del WebSocket Server: ", response["response"])
		else:
			print("Error al procesar la respuesta JSON")
	else:
		print("Error en la respuesta HTTP: ", response_code)
