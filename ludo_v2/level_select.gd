extends Control

var level_1: String = "res://Tableros/Escenas_tablero/mapa_1.tscn"
var level_2: String = "res://Tableros/Escenas_tablero/mapa_2.tscn"

func change_scene():
	get_tree().change_scene_to_file("res://Interfaz/Interfaz_Escenas/Character_Select.tscn")

func _on_level_1_pressed() -> void:
	global_var.sceneSelect = level_1
	change_scene()

func _on_level_2_pressed() -> void:
	global_var.sceneSelect = level_2
	change_scene()
