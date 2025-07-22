extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Game.progress.gates_down:
		visible = false
