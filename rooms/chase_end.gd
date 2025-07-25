extends Area2D


var activated = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if !Game.progress.deeplab_complete and !activated:
			activated = true
			body.pstate = body.PLAYERSTATE.CUTSCENE
			body.swap_anim("walk_up")
			body.direction = Vector2(0, -1)
			
			await get_tree().create_timer(1).timeout
			
			get_tree().call_group("player", "set_camera_link", false)
			
			var ref_labsentry = get_tree().get_first_node_in_group("lab_sentry")
			if ref_labsentry != null:
				var new_tween = create_tween().tween_property(ref_labsentry, "progress_ratio", 1, 3)
				
				await get_tree().create_timer(0.5).timeout
				
				body.direction = Vector2.ZERO
				body.swap_anim("idle_down")
				body.dir = body.PLAYERDIR.DOWN
				
				await get_tree().create_timer(0.5).timeout
				
				get_tree().call_group("door", "call_deferred", "rise")
				await new_tween.finished
				
				await get_tree().create_timer(1).timeout
				
				Audio.play_sound("res://sounds/sndSentryAlert.mp3", "labsentry", 0.0, false, 0.8)
				get_tree().call_group("camera", "shake", 5, 120, 1)
				
				await get_tree().create_timer(3).timeout
				
				var tween2 = create_tween().tween_property(ref_labsentry, "progress_ratio", 0, 3)
				
				await get_tree().create_timer(1).timeout

			get_tree().call_group("camera", "new_position", Vector2(0, -50), 0.5, true)
			
			await get_tree().create_timer(0.5).timeout
			
			get_tree().call_group("camera", "reset_pos", 0.01)
			get_tree().call_group("player", "set_camera_link", true)
			body.pstate = body.PLAYERSTATE.ALIVE
