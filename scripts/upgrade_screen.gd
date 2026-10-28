class_name UpgradeScreen
extends CanvasLayer

signal upgrade_selected(upgrade: Upgrade)

@export var button: Button
@export var button_2: Button
@export var button_3: Button


const UPGRADES_LIST: Array[Upgrade] = [
	preload("res://resources/upgrades/attack_speed_up.tres"),
	preload("res://resources/upgrades/damage_up.tres"),
	preload("res://resources/upgrades/heavy_blade.tres"),
	preload("res://resources/upgrades/max_health_up.tres"),
	preload("res://resources/upgrades/speed_up.tres"),
]

func show_random_upgrades() -> void:
	# Obtener la lista de upgrades y aplicarles suffle para que se muevan aleatoriamente
	var available_upgrades: Array[Upgrade] = UPGRADES_LIST.duplicate()
	available_upgrades.shuffle()
	
	# Obtener solo 3
	var random_upgrades: Array[Upgrade] = available_upgrades.slice(0, 3)
	
	# Meter los botones a un array
	var buttons: Array[Button] = [button, button_2, button_3]
	
	for i in range(3):
		var upgrade: Upgrade = random_upgrades[i]
		buttons[i].text = upgrade.name + "\n" + upgrade.description
		buttons[i].pressed.connect(_on_upgrade_button_pressed.bind(upgrade))
		
		
func _on_upgrade_button_pressed(upgrade: Upgrade) -> void:
	upgrade_selected.emit(upgrade)
