extends AnimatedSprite2D
signal piece_clicked(jugador_num, indice_pieza)

var ficha_id: int  # Identificador único de la ficha
var jugador_num: int  # Número del jugador (1 o 2)
var indice_pieza: int  # Índice de la pieza (0 a 3)

func _input(event):
	if event.is_action_pressed("toque"):
		# Obtiene el nombre de la animación actual y el número de frame actual
		var current_animation = animation
		var current_frame = frame

		# Obtiene la textura del frame actual de la animación
		var frame_texture = sprite_frames.get_frame_texture(current_animation, current_frame)
		var local_mouse_pos = get_local_mouse_position()

		if frame_texture and frame_texture is Texture2D:
			# Convertir las coordenadas del mouse a las coordenadas de la textura
			var tex_size = frame_texture.get_size()
			var image = frame_texture.get_image()

			# Transformamos las coordenadas locales a las de la textura
			var texture_pos = local_mouse_pos / get_scale() + tex_size / 2  # Ajuste según la escala y centro de la textura

			# Verificamos si las coordenadas están dentro de la textura
			if texture_pos.x >= 0 and texture_pos.x < tex_size.x and texture_pos.y >= 0 and texture_pos.y < tex_size.y:
				var pixel_color = image.get_pixelv(texture_pos)

				if pixel_color.a > 0.5:  # Verifica si el píxel es opaco
					print("Se presionó la ficha con ID: ", ficha_id)
					# Emitir la señal con jugador_num y indice_pieza
					emit_signal("piece_clicked", jugador_num, indice_pieza)
