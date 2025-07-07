extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("dead")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animated_sprite_2d_animation_looped() -> void:
	print("move")
	position.x -= 4




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !Game.progress.deeplab_complete:
		Game.progress.deeplab_complete = true
		$flashlight.enabled = true
		$s22_cutscene/CollisionShape2D.disabled = true
		$objCollectible.visible = false
		$AnimatedSprite2D.play("crawl")
		body.pstate = body.PLAYERSTATE.CUTSCENE
		body.direction = Vector2.ZERO
		body.swap_anim("idle_right")
		get_tree().call_group("camera", "new_position", Vector2(130, 0), 1.5, true)
		await get_tree().create_timer((1.2*8)+0.2).timeout
		print("play cutscene")
		$AnimatedSprite2D.stop()
		$s22_cutscene/AnimationPlayer.play("die")
		await $s22_cutscene/AnimationPlayer.animation_finished
		get_tree().call_group("camera", "reset_pos", 1)
		await get_tree().create_timer(0.8).timeout
		body.pstate = body.PLAYERSTATE.ALIVE
