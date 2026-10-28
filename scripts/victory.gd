extends CanvasLayer

func _on_button_pressed() -> void:
	GameState.reset()
	get_tree().change_scene_to_file("res://scenes/room_1.tscn")
