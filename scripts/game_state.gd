extends Node


const LEVEL_PATHS: Array[String] = [
	"res://scenes/room_1.tscn",
	"res://scenes/room_2.tscn",
	"res://scenes/room_3.tscn"
]

var actual_room: int = 0
var actual_health_player: float = 0.0
var is_new_match: bool = true

func reset() -> void:
	actual_room = 0
	actual_health_player = 0.0
	is_new_match = true
