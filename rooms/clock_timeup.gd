extends Node

var listen = false

func _ready():
	$CanvasLayer/Label2.text = "Press " + Game.get_input_sprite() + " to try again"
	Game.progress_set("last_room", "res://rooms/rmClockStart.tscn")
	Game.roomtargetx = 0
	Game.roomtargety = 0
	Audio.play_sound("res://sounds/sndDeath.ogg", "timeup")
	await get_tree().create_timer(0.5).timeout
	listen = true

func _input(event: InputEvent) -> void:
	$CanvasLayer/Label2.text = "Press " + Game.get_input_sprite() + " to try again"
	if Input.is_action_just_pressed("ui_accept") and listen:
		listen = false
		Game.transition_room("res://rooms/rmClockStart.tscn")
