extends Node

var listen = false

func _ready():
	Game.progress_set("last_room", "res://rooms/rmClockStart.tscn")
	await get_tree().create_timer(0.5).timeout
	listen = true

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept") and listen:
		listen = false
		Game.transition_room("res://rooms/rmClockStart.tscn")
