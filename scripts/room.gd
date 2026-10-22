extends Node2D

# Constantes
const ENEMY_SCENE: PackedScene = preload("res://scenes/enemy.tscn")
# Referencias
@onready var enemy_spawns: Node2D = $EnemySpawns

func _ready() -> void:
	# Recorrer todos los enemigos del spawn
	for spawn: Marker2D in enemy_spawns.get_children():
		# Instanciar al enemigo
		var enemy: Enemy = ENEMY_SCENE.instantiate()
		
		# Añadir primero al árbol como hijo de este cuarto (self)
		add_child(enemy)
		
		# Asignar la posición global DESPUÉS de estar en el árbol
		enemy.global_position = spawn.global_position
		
