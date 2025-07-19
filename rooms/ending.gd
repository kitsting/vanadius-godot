extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.pstate = body.PLAYERSTATE.CUTSCENE
		body.swap_anim("walk_up")
		body.direction = Vector2(0, -1)
		
		await get_tree().create_timer(1.4).timeout
		
		body.direction = Vector2(0, 0)
		body.swap_anim("idle_up")
		
		await get_tree().create_timer(2).timeout
		
		get_tree().call_group("camera", "new_position", Vector2(0, -50), 2, true)
		
		await get_tree().create_timer(4).timeout
		
		get_tree().call_group("camera", "new_position", Vector2(0, -180), 2, true)
		
		Audio.stop_music(1, 10)
		
		await get_tree().create_timer(10).timeout
		
		Game.stats.game_completed = true
		Game.transition_room("res://ui/ending_bad.tscn")
