extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Game.progress.deeplab_complete:
		play("dead")
	else:
		play("alive")
