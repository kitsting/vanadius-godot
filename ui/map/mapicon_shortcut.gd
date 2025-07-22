extends TextureRect

@export var shortcut_id : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if shortcut_id in Game.progress.gates:
		texture = load("res://sprites/ui/map/mapicon_shortcut_clear.png")
