extends Control

var can_input : bool = false

# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	if can_input:
		if Input.is_action_pressed("ui_up"):
			$map.position.y += 1 * delta * 60
		if Input.is_action_pressed("ui_down"):
			$map.position.y -= 1 * delta * 60

		$map.position.y = clamp($map.position.y, -120, -60)
