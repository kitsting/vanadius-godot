extends Area2D

var pressed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Game.progress["clock_complete"]:
		$sprite.frame = 2
		$shape.disabled = true
		pressed = true
		if has_node("tiles_l"):
			get_node("tiles_l").position.x -= 90
		if has_node("tiles_r"):
			get_node("tiles_r").position.x += 90
			
		if has_node("pit_l"):
			get_node("pit_l").set_disabled(false)
			
		if has_node("pit_r"):
			get_node("pit_r").set_disabled(false)
			
		if has_node("wall_tile"):
			get_node("wall_tile").collision_enabled = true
	else:
		if has_node("pit_l"):
			get_node("pit_l").set_disabled(true)
			
		if has_node("pit_r"):
			get_node("pit_r").set_disabled(true)
			
		if has_node("wall_tile"):
			get_node("wall_tile").collision_enabled = false



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !pressed:
		pressed = true
		$shape.disabled = true
		get_tree().call_group("camera", "shake", 0.5, 45, 2)
		$AudioStreamPlayer.play()
		Game.progress_set("clock_complete", true)
		$sprite.play()
		
		if has_node("tiles_l"):
			create_tween().tween_property(get_node("tiles_l"), "position", get_node("tiles_l").position - Vector2(90, 0), 2)
			
		if has_node("tiles_r"):
			create_tween().tween_property(get_node("tiles_r"), "position", get_node("tiles_r").position + Vector2(90, 0), 2)
			
		if has_node("wall_tile"):
			get_node("wall_tile").collision_enabled = true
			
		await get_tree().create_timer(1.5).timeout
			
		if has_node("pit_l"):
			get_node("pit_l").set_disabled(false)
			
		if has_node("pit_r"):
			get_node("pit_r").set_disabled(false)
			
		Game.stop_clock_timer()
		Game.progress.towertime_left = -4
