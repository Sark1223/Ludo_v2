extends Node2D

# Referencia al AnimatedSprite2D hijo
@onready var animated_sprite = $AnimatedSprite2D

func _input(event):
	if event.is_action_pressed("toque"):
		# Obtener la posición del mouse en relación al AnimatedSprite2D
		var local_mouse_pos = animated_sprite.to_local(get_global_mouse_position())
		
		# Obtiene el nombre de la animación actual y el número de frame actual
		var current_animation = animated_sprite.animation
		var current_frame = animated_sprite.frame

		# Obtiene la textura del frame actual de la animación
		var frame_texture = animated_sprite.sprite_frames.get_frame_texture(current_animation, current_frame)

		if frame_texture and frame_texture is Texture2D:
			# Convertir las coordenadas del mouse a las coordenadas de la textura
			var tex_size = frame_texture.get_size()
			var image = frame_texture.get_image()

			# Transformamos las coordenadas locales a las de la textura
			var texture_pos = local_mouse_pos / animated_sprite.get_scale() + tex_size / 2  # Ajuste según la escala y centro de la textura

			# Verificamos si las coordenadas están dentro de la textura
			if texture_pos.x >= 0 and texture_pos.x < tex_size.x and texture_pos.y >= 0 and texture_pos.y < tex_size.y:
				var pixel_color = image.get_pixelv(texture_pos)

				if pixel_color.a > 0.5:  # Verifica si el píxel es opaco
					print("se presionó")
