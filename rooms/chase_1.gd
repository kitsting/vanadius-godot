extends Area2D

var activated := false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if !Game.progress.deeplab_complete and !activated:
			activated = true
			body.pstate = body.PLAYERSTATE.CUTSCENE
			body.direction = Vector2.ZERO
			body.swap_anim("idle_down")
			get_tree().call_group("door", "call_deferred", "rise")
			
			if !Game.chase_cutscene_seen:
				await get_tree().create_timer(1.5).timeout
			
			body.swap_anim("idle_right", true)
			
			get_tree().call_group("player", "set_camera_link", false)
			get_tree().call_group("camera", "new_position", Vector2(170, 150), 1, false)
			
			if !Game.chase_cutscene_seen:
				await get_tree().create_timer(1.5).timeout
			
			var ref_labsentry : Node = get_tree().get_first_node_in_group("lab_sentry")
			if ref_labsentry != null:
				var new_tween := create_tween()
				if !Game.chase_cutscene_seen:
					new_tween.tween_property(ref_labsentry, "progress", 100, 3)
				else:
					new_tween.tween_property(ref_labsentry, "progress", 100, 1.5)
				await new_tween.finished
				
				await get_tree().create_timer(0.5).timeout
				
				Audio.play_sound("res://sounds/sndSentryAlert.mp3", "labsentry", 0.0, false, 0.8)
				get_tree().call_group("camera", "shake", 4, 60, 1)
				if !Game.chase_cutscene_seen:
					await get_tree().create_timer(3).timeout
				else:
					await get_tree().create_timer(2).timeout
				ref_labsentry.state = ref_labsentry.MODE.FOLLOW_PATH

			get_tree().call_group("camera", "reset_pos", 0.25)
			get_tree().call_group("player", "set_camera_link", true)
			body.pstate = body.PLAYERSTATE.ALIVE
			
			Game.chase_cutscene_seen = true
