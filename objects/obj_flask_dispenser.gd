@tool
extends Area2D

enum dir {
	DOWN = 270,
	LEFT = 180,
	RIGHT = 0
}

@export var direction := dir.DOWN:
	set(value):
		direction = value
		if value == dir.DOWN:
			$Sprite2D.animation = "down"
			$down_shape.disabled = false
			$side_shape.disabled = true
		else:
			$down_shape.disabled = true
			$side_shape.disabled = false
			$Sprite2D.animation = "side"
			if value == dir.LEFT:
				$Sprite2D.flip_h = true
			elif value == dir.RIGHT:
				$Sprite2D.flip_h = false
		
@export var z_index_override : int = 0

@export var timer : float = 1.0
@export var offset : float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !Engine.is_editor_hint():
		await get_tree().create_timer(offset).timeout
		
		$Timer.start(timer)


func _on_timer_timeout() -> void:
	var spawn_offset := Vector2.ZERO
	#if direction == dir.DOWN:
		#spawn_offset = Vector2(0, -4)
	#elif direction == dir.LEFT:
		#spawn_offset = Vector2(4, 0)
	#elif direction == dir.RIGHT:
		#spawn_offset = Vector2(-4, 0)
	var new_flask : Node = load("res://objects/objFlask.tscn").instantiate()
	new_flask.position += spawn_offset
	new_flask.direction = direction
	add_child(new_flask)
	new_flask.z_index += z_index_override
