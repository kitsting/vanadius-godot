extends CanvasLayer

@export var play_intro := true

var counting = false

var display_time = 0

signal keypress


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !Game.progress.clock_complete:
		if play_intro:
			counting = false
			play_intro_anim()
		else:
			counting = true
	else:
		Game.progress_set("last_room", "res://rooms/rmClockFloor1.tscn")
		Game.transition_room("res://rooms/rmClockFloor1.tscn")
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if counting:
		$hbox/time.text = str(int(Game.progress.towertime_left))
	else:
		$hbox/time.text = str(int(display_time))

func _input(event) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("keypress")

func play_intro_anim() -> void:
	$hbox.position.y -= 100
	await create_tween().tween_property(self, "display_time", Game.m_towertimermax, 2).finished
	await keypress
	await create_tween().tween_property($hbox, "position", $hbox.position + Vector2(0,100), 1).finished
	Game.progress.towertime_left = Game.m_towertimermax
	Game.progress_set("last_room", "res://rooms/rmClockFloor1.tscn")
	Game.transition_room("res://rooms/rmClockFloor1.tscn")
	Game.start_clock_timer()
	counting = true
