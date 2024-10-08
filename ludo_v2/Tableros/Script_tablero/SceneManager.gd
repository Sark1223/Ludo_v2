extends Node2D

@export var Ficha1Scene : PackedScene  # Escena para el tipo "sombrero"
@export var Ficha2Scene : PackedScene  # Escena para el tipo "gato"
@export var Ficha3Scene : PackedScene  # Escena para el tipo "tortuga"
@export var Ficha4Scene : PackedScene  # Escena para el tipo "mono"

# Definimos los desplazamientos para las 4 fichas en forma de cuadrado
@export var ficha_offsets : Array[Vector2] = [
	Vector2(0, 0),      # Esquina superior izquierda
	Vector2(65, 0),     # A la derecha (esquina superior derecha)
	Vector2(0, 65),     # Abajo (esquina inferior izquierda)
	Vector2(65, 65)     # Diagonal (esquina inferior derecha)
]

func _ready():
	var index = 0
	for i in GameManager.Players:
		var currentFicha
		
		# Alternar entre Ficha1, Ficha2, Ficha3 y Ficha4 para asignar diferentes personajes
		for ficha_index in range(4):  # Crear 4 fichas para cada jugador
			match index:
				0:
					currentFicha = Ficha1Scene.instantiate()  # Jugador 1: Fichas de sombrero
				1:
					currentFicha = Ficha2Scene.instantiate()  # Jugador 2: Fichas de gato
				2:
					currentFicha = Ficha3Scene.instantiate()  # Jugador 3: Fichas de tortuga
				3:
					currentFicha = Ficha4Scene.instantiate()  # Jugador 4: Fichas de mono
			
			# Asignar un ID único a cada ficha
			currentFicha.ficha_id = index * 4 + ficha_index
			
			# Añadir la ficha a la escena
			add_child(currentFicha)

			# Posicionar al jugador en el spawn point correspondiente
			for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
				if spawn.name == str(index):
					# Usamos el array de desplazamientos para cada ficha
					var offset_position = ficha_offsets[ficha_index]
					currentFicha.global_position = spawn.global_position + offset_position
		
		index += 1


	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
