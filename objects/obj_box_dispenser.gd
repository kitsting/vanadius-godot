@tool
extends Area2D

@export var facing_left = false:
	set(value):
		facing_left = value
		$Sprite2D.flip_h = value
		
@export var z_index_override = 0;
		
var current_box : Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		if current_box == null:
			var offset = -4
			if facing_left:
				offset = -offset
			current_box = load("res://objects/objPackageMoveable.tscn").instantiate()
			current_box.position.x += offset
			current_box.position.y += 1
			add_child(current_box)
			current_box.z_index += z_index_override
