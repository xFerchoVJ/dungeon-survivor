extends Node2D
@onready var player: Player = $Player
@onready var hud: Hud = $hud

func _ready() -> void:
	hud.update_bar(player.health, player.max_health)
	player.health_changed.connect(_on_health_changed)
func _on_health_changed(actual_health: float, max_health: float) -> void:
	hud.update_bar(actual_health, max_health)
	
