class_name Player
extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sword_pivot: Node2D = $SwordPivot
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_cooldown: Timer = $AttackCooldown
@onready var hit_cooldown: Timer = $HitCooldown

@export var speed: float = 60
@export var damage: float = 50.0
@export var max_health: float = 100.0

var facing: Vector2 = Vector2.DOWN
var bounce_time: float = 0.0
var bounce_frequency: float = 12.0
var bounce_amplitude: float = 1.0
var health: float = 100.0
var damage_tween: Tween

func _ready() -> void:
	health = max_health

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
	
	# Mover la espada hacia donde mira el player
	sword_pivot.rotation = facing.angle()
	
	# Atacar
	attack()
	
	# Voltear el sprite horizontalmente
	flip_player(direction)
		
	# Robote al caminar
	apply_bounce_animation(direction, delta)
		
func attack() -> void:
	if Input.is_action_just_pressed("attack") and attack_cooldown.is_stopped():
		animation_player.play("attack")
		attack_cooldown.start()

func flip_player(direction: Vector2) -> void:
	if direction.x < 0:
		sprite_2d.flip_h = true
	elif direction.x > 0:
		sprite_2d.flip_h = false
		
func apply_bounce_animation(direction: Vector2, delta: float) -> void:
	if direction != Vector2.ZERO:
		bounce_time += delta
		sprite_2d.position.y = sin(bounce_time * bounce_frequency) * bounce_amplitude
	else:
		sprite_2d.position.y = move_toward(
			sprite_2d.position.y,
			0.0,
			5.0 * delta
		)

func _on_hitbox_area_entered(area: Area2D) -> void:
	var owner_node: Node = area.get_parent()
	if owner_node is Enemy:
		owner_node.take_damage(damage, global_position)
		
func take_damage(qty: float, position_hitter: Vector2) -> void:
	if not hit_cooldown.is_stopped():
		return
		
	health -= qty
	
	if health <= 0.0:
		print("Se murió el player")
		return
	
	hit_cooldown.start()
	_apply_damage_tween()


func _apply_damage_tween() -> void:
	reset_tween()

	damage_tween = create_tween()
	damage_tween.set_loops()
	
	damage_tween.tween_property(
		sprite_2d,
		"modulate",
		Color.RED,
		0.1
	)
	
	damage_tween.tween_property(
		sprite_2d,
		"modulate",
		Color.WHITE,
		0.1
	)


func _on_hit_cooldown_timeout() -> void:
	reset_tween()


func reset_tween() -> void:
	if damage_tween and damage_tween.is_running():
		damage_tween.kill()
		
	sprite_2d.modulate = Color.WHITE
