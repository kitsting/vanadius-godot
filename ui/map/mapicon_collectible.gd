extends TextureRect

@export var collectible_id := ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if collectible_id in Game.progress.collectibles:
		texture = load("res://sprites/ui/map/mapicon_collectible_filled.png")
