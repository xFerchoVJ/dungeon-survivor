extends Node


const LEVEL_PATHS: Array[String] = [
	"res://scenes/room_1.tscn",
	"res://scenes/room_2.tscn",
	"res://scenes/room_3.tscn"
]

var actual_room: int = 0
var actual_health_player: float = 0.0
var is_new_match: bool = true

var upgrades_applied: Dictionary[String, float] = {
	"bonus_damage": 0.0,
	"bonus_health": 0.0,
	"bonus_speed": 0.0,
	"bonus_attack_speed": 0.0
}

func _ready() -> void:
	var audio = AudioStreamPlayer.new()
	audio.stream = preload("res://audio/music.wav")
	audio.bus = "Music"
	add_child(audio)
	audio.play()

func apply_upgrade(upgrade: Upgrade) -> void:
	match upgrade.upgrade_type:
		Upgrade.UpgradeType.DAMAGE:
			upgrades_applied["bonus_damage"] += upgrade.value
		Upgrade.UpgradeType.MAX_HEALTH:
			upgrades_applied["bonus_health"] += upgrade.value
		Upgrade.UpgradeType.SPEED:
			upgrades_applied["bonus_speed"] += upgrade.value
		Upgrade.UpgradeType.ATTACK_SPEED:
			upgrades_applied["bonus_attack_speed"] += upgrade.value

func reset() -> void:
	actual_room = 0
	actual_health_player = 0.0
	is_new_match = true
	reset_upgrades()
	
	
func reset_upgrades() -> void:
	upgrades_applied["bonus_damage"] = 0.0
	upgrades_applied["bonus_health"] = 0.0
	upgrades_applied["bonus_speed"] = 0.0
	upgrades_applied["bonus_attack_speed"] = 0.0
