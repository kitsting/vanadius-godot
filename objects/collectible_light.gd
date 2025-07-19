extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Game.progress.bonus_revealed:
		play("on")
	else:
		play("off")


func turn_on() -> void:
	play("on")
