extends Control

@onready var StartGame
@onready var Host_button
@onready var Join_button
@onready var ExitGame_button

# Pre-cargar las escenas para Host, Join y Menu
@onready var Host_scene = "res://Host_scene.tscn"
@onready var Join_scene = "res://Join_scene.tscn"
@onready var Menu_scene = "res://Menu_scene.tscn"

@onready var http_request = $HTTPRequest  # Nodo HTTPRequest

# Función para cambiar a la escena de Join
func _on_on_join_button_pressed() -> void:
	if Join_scene:
		get_tree().change_scene_to_file(Join_scene)  # Usamos change_scene y la ruta de la escena
	else:
		print("Error: No se pudo cargar la escena de Join.")

# Función para cambiar a la escena de Host
func _on_on_host_button_pressed() -> void:
	if Host_scene:
		get_tree().change_scene_to_file(Host_scene)  # Usamos change_scene y la ruta de la escena
	else:
		print("Error: No se pudo cargar la escena de Host.")

# Función para salir del juego
func _on_on_exit_game_button_pressed() -> void:
	print("Saliendo del juego...")
	get_tree().quit()

# Función de conexión WebSocket si es necesario para comunicación en tiempo real
# Aquí puedes agregar la lógica de WebSocket si tu servidor lo soporta
