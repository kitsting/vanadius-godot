extends TextureRect

@export var point_to := ""


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if point_to in Game.progress.visited_rooms:
			queue_free()
