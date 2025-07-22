extends Control

var can_input : bool = false:
	set(value):
		can_input = value
		if value == false:
			$nodes.position = remember_offset

var remember_offset := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	if can_input:
		if Input.is_action_pressed("ui_up"):
			$nodes.position.y += 1 * delta * 60
		if Input.is_action_pressed("ui_down"):
			$nodes.position.y -= 1 * delta * 60
		if Input.is_action_pressed("ui_left"):
			$nodes.position.x += 1 * delta * 60
		if Input.is_action_pressed("ui_right"):
			$nodes.position.x -= 1 * delta * 60

		#$map.position.y = clamp($map.position.y, -120, -60)


func move_position(new_offset : Vector2) -> void:
	$nodes.position = -new_offset
	remember_offset = -new_offset
