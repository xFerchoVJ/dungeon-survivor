class_name Hud
extends CanvasLayer
@onready var progress_bar: ProgressBar = $ProgressBar


func update_bar(actual_health: float, max_health: float) -> void:
	progress_bar.max_value = max_health
	progress_bar.value = actual_health
