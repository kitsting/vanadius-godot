extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Game.progress["gates_down"]:
		frame = 9
	Game.connect("gates_lowered", play)
