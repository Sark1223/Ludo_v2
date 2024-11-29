extends Control 
#@onready var menu = $Menu
@onready var popup = $Emergente

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_btn_jugar_pressed() -> void:
	$Timer.start()
	popup.show()
	
	

func _on_btn_salir_pressed() -> void:
	get_tree().quit()


func _on_timer_timeout() -> void:
	popup.hide() 


func _on_btn_online_pressed() -> void:
	pass # Replace with function body.


func _on_btn_local_pressed() -> void:
	
	var scene = load("res://Interfaz/Interfaz_Escenas/multi_control.tscn").instantiate()
	get_tree().root.add_child(scene) 
	#get_tree().change_scene_to_file(scene)


func _on_emergente_close_requested() -> void:
	popup.hide()
