extends Control 
@onready var menu = $Menu
@onready var popup = $Emergente

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_jugar_pressed() -> void:
	#get_tree().change_scene_to_file("res://Mapas/MapaIsleño/tumba_del_heroe.tscn")
	#get_tree().change_scene_to_file("res://Interfaz/Interfaz_Escenas/tipo_conexion_popUp.tscn")
	#DisplayServer.window_set_size(Vector2(942, 734))
	popup.show()
	

func _on_btn_salir_pressed() -> void:
	get_tree().quit()



func _on_emergente_close_requested() -> void:
	popup.hide()