class_name Door
extends StaticBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func open() -> void:
	animated_sprite_2d.play("open")

func _on_animated_sprite_2d_animation_finished() -> void:
	collision_shape_2d.set_deferred("disabled", true)
