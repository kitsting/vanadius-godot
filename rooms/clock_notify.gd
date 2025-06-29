extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.25).timeout
	Game.stop_clock_timer()
	await get_tree().create_timer(0.75).timeout
	Game.add_clock_ui(true)
