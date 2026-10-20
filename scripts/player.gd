class_name Player
extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sword_pivot: Node2D = $SwordPivot
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var speed: float = 60

var facing: Vector2 = Vector2.DOWN
var bounce_time: float = 0.0
var bounce_frequency: float = 12.0
var bounce_amplitude: float = 1.0

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector(
		"move_left",
		"move_right", 
		"move_up", 
		"move_down"
	)
	velocity = direction * speed
	move_and_slide()
	
	# Guardar la última dirección válida
	if direction != Vector2.ZERO:
		facing = direction
	
	sword_pivot.rotation = facing.angle()
	
	if Input.is_action_pressed("ui_accept"):
		animation_player.play("attack")
	
	# Voltear el sprite horizontalmente
	if direction.x < 0:
		sprite_2d.flip_h = true
	elif direction.x > 0:
		sprite_2d.flip_h = false
		
	# Robote al caminar
	if direction != Vector2.ZERO:
		bounce_time += delta
		sprite_2d.position.y = sin(bounce_time * bounce_frequency) * bounce_amplitude
	else:
		sprite_2d.position.y = move_toward(
			sprite_2d.position.y,
			0.0,
			5.0 * delta
		)
