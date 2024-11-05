class_name  MainMenu
extends Control

@onready var Start_button = $MarginContainer/HBoxContainer/VBoxContainer/Separator2/StartGame as Button
@onready var Host_button =  $MarginContainer/HBoxContainer/VBoxContainer/Separator2/StartGame/Host as Button
@onready var Join_button =  $MarginContainer/HBoxContainer/VBoxContainer/Separator2/StartGame/Host/Join as Button
@onready var Exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Separator2/StartGame/Host/Join/ExitGame as Button

@onready var start_button = preload("res://menu.tscn")



func _ready():
	start_button.button_down.connect(" ")
	Host_button.button_down.connect(on_Host_pressed)
	Join_button.button_down.connect(on_Join_pressed)
	Exit_button.button_down.connect(on_exit_pressed)
	
func on_button_down() -> void:
	get_tree().change_scene_to_packed(start_button)
	
func on_Host_pressed() -> void:
	pass
	
func on_Join_pressed() -> void:
	pass

func on_exit_pressed() -> void:
	get_tree().quit()
	
