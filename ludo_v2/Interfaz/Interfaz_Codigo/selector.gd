extends Control

var turtle: String = ""
var monkey: String = "res://Personajes/Escenas_personajes/mono.tscn"
var cat: String = "res://Personajes/Escenas_personajes/gatito.tscn"
var hat: String = "res://Personajes/Escenas_personajes/sombrero.tscn"
var dog: String = ""

func change_scene():
	get_tree().change_scene_to_file("res://Tableros/Escenas_tablero/mapa_1.tscn")

func _on_turtle_pressed() -> void:
	global_var.playerChar = turtle
	change_scene()


func _on_monkey_pressed() -> void:
	global_var.playerChar = monkey
	change_scene()


func _on_cat_pressed() -> void:
	global_var.playerChar = cat
	change_scene()


func _on_hat_pressed() -> void:
	global_var.playerChar = hat
	change_scene()


func _on_dog_pressed() -> void:
	global_var.playerChar = dog
	change_scene()
