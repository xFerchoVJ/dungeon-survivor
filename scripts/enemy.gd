
class_name Enemy
extends CharacterBody2D


# ==================================================
# ESTADOS
# ==================================================

enum State {
	IDLE,
	CHASE,
	HURT
}


# ==================================================
# REFERENCIAS
# ==================================================

@onready var sprite_2d: Sprite2D = $Sprite2D


# ==================================================
# CONFIGURACIÓN
# ==================================================

@export_group("Vida")
@export var max_health: float = 100.0

@export_group("Movimiento")
@export var chase_speed: float = 40.0
@export var knockback_strength: float = 150.0
@export var knockback_friction: float = 600.0

@export_group("Detección")
@export var detection_radius: float = 60.0


# ==================================================
# VARIABLES INTERNAS
# ==================================================

var health: float = 0.0
var current_state: State = State.IDLE

var player: Player
var damage_tween: Tween


# ==================================================
# CICLO DE VIDA
# ==================================================

func _ready() -> void:
	health = max_health
	player = get_tree().get_first_node_in_group("player") as Player


func _physics_process(delta: float) -> void:
	match current_state:
		State.IDLE:
			_process_idle(delta)

		State.CHASE:
			_process_chase(delta)

		State.HURT:
			_process_hurt(delta)

	move_and_slide()


# ==================================================
# COMPORTAMIENTO DE LOS ESTADOS
# ==================================================

func _process_idle(delta: float) -> void:
	_apply_friction(delta)

	if not is_instance_valid(player):
		return

	var distance: float = global_position.distance_to(
		player.global_position
	)

	if distance <= detection_radius:
		current_state = State.CHASE


func _process_chase(delta: float) -> void:
	if not is_instance_valid(player):
		current_state = State.IDLE
		_apply_friction(delta)
		return

	var direction: Vector2 = global_position.direction_to(
		player.global_position
	)

	velocity = direction * chase_speed


func _process_hurt(delta: float) -> void:
	_apply_friction(delta)

	if velocity.is_zero_approx():
		if is_instance_valid(player):
			current_state = State.CHASE
		else:
			current_state = State.IDLE


# ==================================================
# MOVIMIENTO
# ==================================================

func _apply_friction(delta: float) -> void:
	velocity = velocity.move_toward(
		Vector2.ZERO,
		knockback_friction * delta
	)


# ==================================================
# SISTEMA DE DAÑO
# ==================================================

func take_damage(qty_damage: float, position_hitter: Vector2) -> void:
	health -= qty_damage

	if health <= 0.0:
		queue_free()
		return

	current_state = State.HURT
	_apply_knockback(position_hitter)
	_apply_damage_tween()


func _apply_knockback(position_hitter: Vector2) -> void:
	var direction: Vector2 = (
		global_position - position_hitter
	).normalized()

	velocity = direction * knockback_strength


# ==================================================
# EFECTOS VISUALES
# ==================================================

func _apply_damage_tween() -> void:
	if damage_tween and damage_tween.is_running():
		damage_tween.kill()

	sprite_2d.modulate = Color.WHITE

	damage_tween = create_tween()
	damage_tween.set_trans(Tween.TRANS_SINE)
	damage_tween.set_ease(Tween.EASE_IN_OUT)

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
