class_name Upgrade
extends Resource

enum UpgradeType {
	DAMAGE,
	MAX_HEALTH,
	SPEED,
	ATTACK_SPEED
}

@export var name: String = ""
@export_multiline() var description: String = ""
@export var upgrade_type: UpgradeType
@export var value: float = 0.0
