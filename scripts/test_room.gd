extends Node2D
@onready var player: Player = $Player
@onready var hud: Hud = $Hud


func _ready() -> void:
	hud.update_bar(player.health, player.max_health)
	player.health_changed.connect(_on_health_changed)
	player.died.connect(_on_died)
	

func _on_health_changed(actual_health: float, max_health: float) -> void:
	hud.update_bar(actual_health, max_health)
	
	
func _on_died() -> void:
	player.die()
	var enemies: Array[Node] = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy.set_physics_process(false)
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
