extends Enemy
class_name ChargerEnemy

@export_group("Embestida")
@export var notice_distance: float = 40.0
@export var notice_duration: float = 0.6
@export var charge_speed: float = 100.0
@export var charge_duration: float = 0.5
@export var recovery_duration: float = 1.5

var notice_remaining_time: float = 0.0
var windup_tween: Tween
var charge_direction: Vector2 = Vector2.ZERO
var charge_applied_time: float = 0.0
var charge_recover_time: float = 0.0

func _update_state(delta: float) -> void:
	# Actualizar el estado actual
	match current_state:
		State.WINDUP:
			_process_windup(delta)
		State.CHARGE:
			_process_charge(delta)
		State.RECOVER:
			_process_recover(delta)
		_: # Esto significa default
			super(delta) # Los demas estados por default que ya estan en Enemy

func _process_windup(delta: float) -> void:
	velocity = Vector2.ZERO
	charge_applied_time = 0.0
	charge_recover_time = 0.0
	notice_remaining_time -= delta
	if notice_remaining_time <= 0:
		if is_instance_valid(player):
			charge_direction = global_position.direction_to(player.global_position)
			current_state = State.CHARGE
		else:
			current_state = State.IDLE
		
		reset_tween()
	
func _process_charge(delta: float) -> void:
	velocity = charge_direction * charge_speed
	charge_applied_time += delta

	if charge_applied_time >= charge_duration or is_on_wall():
		current_state = State.RECOVER



func _process_recover(delta: float) -> void:
	velocity = Vector2.ZERO
	charge_recover_time += delta
	if charge_recover_time >= recovery_duration:
		current_state = State.CHASE

	
func _process_chase(delta: float) -> void:
	# Continuar con el mismo mecanismo
	super(delta)
	
	# Agregar la parte de windup
	if is_instance_valid(player):
		var distance: float = global_position.distance_to(
			player.global_position
		)
		if distance <= notice_distance:
			current_state = State.WINDUP
			notice_remaining_time = notice_duration
			velocity = Vector2.ZERO
			_start_windup_effect()
			
	
	
func _start_windup_effect() -> void:
	reset_tween()
	
	windup_tween = create_tween()
	windup_tween.set_loops()
	
	windup_tween.tween_property(
		sprite_2d,
		"modulate",
		Color.DARK_ORANGE,
		0.1
	)
	
	windup_tween.tween_property(
		sprite_2d,
		"modulate",
		Color.WHITE,
		0.1
	)
	
func reset_tween() -> void:
	if windup_tween and windup_tween.is_running():
		windup_tween.kill()
		
	sprite_2d.modulate = Color.WHITE


func take_damage(qty_damage: float, position_hitter: Vector2) -> void:
	if current_state == State.WINDUP: reset_tween()
	super(qty_damage, position_hitter)
	
