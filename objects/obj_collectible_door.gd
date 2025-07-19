extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	if Game.progress.bonus_revealed == true:
		$sprite.play("off")
		$sprite.position.y += 48
		$CollisionShape2D.disabled = true
		z_index = -1
	else:
		$sprite.play("on")


func lower() -> void:
	var tween := create_tween()
	tween.tween_property($sprite, "position", $sprite.position + Vector2(0,48), 0.8).set_ease(Tween.EASE_IN)
	await tween.finished
	$sprite.play("off")
	Audio.play_sound("res://sounds/sndExplosion.ogg", "door")
	get_tree().call_group("camera", "shake", 2, 30, 1)
	$CollisionShape2D.disabled = true
	z_index = -1
