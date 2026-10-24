extends Node2D

# Constantes
const ENEMY_SCENE: PackedScene = preload("res://scenes/enemy.tscn")
const PLAYER_SCENE: PackedScene = preload("res://scenes/player.tscn")

# Referencias
@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var enemy_spawns: Node2D = $EnemySpawns
@onready var door: Door = $Door
@onready var hud: Hud = $Hud

# global variables
var enemies_alive: int = 0

func _ready() -> void:
	# Instanciar el jugador
	var player: Player = PLAYER_SCENE.instantiate()
	hud.update_bar(player.health, player.max_health)
	player.health_changed.connect(_on_health_changed)
	player.died.connect(_on_died)
	add_child(player)
	player.global_position = player_spawn.global_position
	
	# Recorrer todos los enemigos del spawn
	for spawn: Marker2D in enemy_spawns.get_children():
		# Instanciar al enemigo
		var enemy: Enemy = ENEMY_SCENE.instantiate()
		# Sumar los enemigos vivo
		enemies_alive += 1
		# Conectar señales
		enemy.died.connect(_on_enemy_died)
		# Añadir primero al árbol como hijo de este cuarto (self)
		add_child(enemy)
		# Asignar la posición global DESPUÉS de estar en el árbol
		enemy.global_position = spawn.global_position
		

func _on_enemy_died() -> void:
	enemies_alive -= 1
	
	if enemies_alive <= 0:
		door.open()

func _on_health_changed(actual_health: float, max_health: float) -> void:
	hud.update_bar(actual_health, max_health)
	
	
func _on_died(player) -> void:
	player.die()
	var enemies: Array[Node] = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy.set_physics_process(false)
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	
	
