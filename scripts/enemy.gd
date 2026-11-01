
class_name Enemy
extends CharacterBody2D

signal died

# ==================================================
# ESTADOS
# ==================================================

enum State {
	IDLE,
	CHASE,
	HURT,
	WINDUP,
	CHARGE,
	RECOVER
}


# ==================================================
# REFERENCIAS
# ==================================================

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hit_box: Area2D = $HitBox
@onready var enemy_hit: AudioStreamPlayer2D = $EnemyHit
@onready var enemy_death: AudioStreamPlayer2D = $EnemyDeath
@onready var hurt_box: Area2D = $HurtBox


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

@export_group("Daño")
@export var damage: float = 25

# ==================================================
# VARIABLES INTERNAS
# ==================================================

var health: float = 0.0
var current_state: State = State.IDLE

var player: Player
var damage_tween: Tween
var is_dead: bool = false

# ==================================================
# CICLO DE VIDA
# ==================================================

func _ready() -> void:
	health = max_health
	player = get_tree().get_first_node_in_group("player") as Player


func _physics_process(delta: float) -> void:
	# Actualizar el estado actual
	_update_state(delta)

	# Aplicar posicion y movimiento
	move_and_slide()

	# Aplicar el daño
	var areas: Array[Area2D] = hit_box.get_overlapping_areas()
	for area in areas:
		_apply_damage_to_player(area)
	


# ==================================================
# COMPORTAMIENTO DE LOS ESTADOS
# ==================================================

func _update_state(delta: float) -> void:
	match current_state:
		State.IDLE:
			_process_idle(delta)

		State.CHASE:
			_process_chase(delta)

		State.HURT:
			_process_hurt(delta)

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
	if is_dead:
		return

	health -= qty_damage

	if health <= 0.0:
		died.emit()
		is_dead = true
		enemy_death.play()
		_desactivate()
		return

	current_state = State.HURT
	_apply_knockback(position_hitter)
	_apply_damage_tween()
	enemy_hit.play()


func _desactivate() -> void:
	visible = false
	set_physics_process(false)
	for item in [hurt_box, hit_box]:
		item.set_deferred("monitorable", false)
		item.set_deferred("monitoring", false)

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

		
func _apply_damage_to_player(area: Area2D) -> void:
	var owner_node: Node = area.get_parent()
	if owner_node is Player:
		if current_state != State.HURT:
			owner_node.take_damage(damage, global_position)


func _on_enemy_death_finished() -> void:
	queue_free()
