
class_name Enemy
extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var max_health: float = 100.0
@export var knockback_strength: float = 150.0
@export var knockback_friction: float = 600.0

var health: float = 0.0
var damage_tween: Tween


# Inicializa la vida del enemigo.
func _ready() -> void:
	health = max_health


# Mueve al enemigo y reduce gradualmente el empujón.
func _physics_process(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, knockback_friction * delta)
	move_and_slide()


# Aplica el daño, el flash rojo y el knockback.
func take_damage(qty_damage: float, position_hitter: Vector2) -> void:
	apply_damage_tween()

	health -= qty_damage

	# Aleja al enemigo en dirección contraria al atacante.
	var knockback_direction: Vector2 = (global_position - position_hitter).normalized()
	velocity = knockback_direction * knockback_strength

	# Elimina al enemigo cuando se queda sin vida.
	if health <= 0:
		queue_free()


# Hace parpadear al enemigo en rojo al recibir daño.
func apply_damage_tween() -> void:
	# Cancela el flash anterior para evitar conflictos.
	if damage_tween and damage_tween.is_running():
		damage_tween.kill()

	sprite_2d.modulate = Color.WHITE

	# Anima el color rojo y después lo devuelve al normal.
	damage_tween = create_tween()
	damage_tween.set_trans(Tween.TRANS_SINE)
	damage_tween.set_ease(Tween.EASE_IN_OUT)

	damage_tween.tween_property(sprite_2d, "modulate", Color.RED, 0.1)
	damage_tween.tween_property(sprite_2d, "modulate", Color.WHITE, 0.1)
