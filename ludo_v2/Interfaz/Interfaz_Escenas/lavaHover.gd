extends TextureRect

@export var hover_scale: float = .95   # Factor de escala al pasar el cursor
@export var scale_duration: float = 0.2  # Duración de la animación de escala

var original_scale: Vector2

func _ready():
	# Guardar la escala original
		original_scale = scale

func _on_mouse_entered():
	# Animar el escalado cuando el cursor entra
	var tween = create_tween()
	tween.tween_property(self, "scale", original_scale * hover_scale, scale_duration)

func _on_mouse_exited():
	# Regresar a la escala original cuando el cursor sale
	var tween = create_tween()
	tween.tween_property(self, "scale", original_scale, scale_duration)
