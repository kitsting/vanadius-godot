extends Control

var can_input : bool = false:
	set(value):
		can_input = value
		if value == false:
			var tween := create_tween()
			tween.tween_property($nodes, "position", remember_offset, 0.15)
			#$nodes.position = remember_offset

var remember_offset := Vector2.ZERO

var scroll_speed : float = 1.5

# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	if can_input:
		
		if Input.is_action_pressed("ui_up"):
			$nodes.position.y += scroll_speed * (delta * 60)
		if Input.is_action_pressed("ui_down"):
			$nodes.position.y -= scroll_speed * (delta * 60)
		if Input.is_action_pressed("ui_left"):
			$nodes.position.x += scroll_speed * (delta * 60)
		if Input.is_action_pressed("ui_right"):
			$nodes.position.x -= scroll_speed * (delta * 60)

	#Lock the map to the used area
	$nodes.position.y = clamp($nodes.position.y, -60, 180)
	$nodes.position.x = clamp($nodes.position.x, -120, 60)


func move_position(new_offset : Vector2) -> void:
	$nodes.position = -new_offset
	remember_offset = -new_offset
