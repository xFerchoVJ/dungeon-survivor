class_name Door
extends StaticBody2D

signal player_outside

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var exit_area: Area2D = $ExitArea

func open() -> void:
	animated_sprite_2d.play("open")

func _on_animated_sprite_2d_animation_finished() -> void:
	collision_shape_2d.set_deferred("disabled", true)
	exit_area.set_deferred("monitoring", true)


func _on_exit_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_outside.emit()
