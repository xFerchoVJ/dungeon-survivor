class_name Enemy
extends CharacterBody2D

@export var max_health: float = 100.0

var health: float = 0.0

func _ready() -> void:
	health = max_health

func take_damage(qty_damage: float, position_hitter: Vector2) -> void:
	health -= qty_damage
	if health <= 0:
		queue_free()
