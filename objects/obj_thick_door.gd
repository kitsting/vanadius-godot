extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.animation = "down"
	z_index = -1
	$CollisionShape2D.disabled = true


func rise() -> void:
	if $AnimatedSprite2D.animation == "down":
		$AnimatedSprite2D.play("rise")
		$CollisionShape2D.disabled = false
		z_index = 0


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "rise":
		$AnimatedSprite2D.animation = "up"
		
		if $VisibleOnScreenNotifier2D.is_on_screen():
			get_tree().call_group("camera", "shake", 1, 30, 1)
			Audio.play_sound("res://sounds/sndBigPressurePlate.ogg", "door", 0, false, 0.9)
