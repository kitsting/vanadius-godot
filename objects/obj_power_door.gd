extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	if Game.progress.power_complete == true:
		$sprite.play("off")
		$sprite.position.y += 48
		$CollisionShape2D.disabled = true
		z_index = -1
	else:
		$sprite.play("on")
