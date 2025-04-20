@tool
extends StaticBody2D

@export_enum("Left", "Right", "Down") var direction : int = 1:
	set(value):
		direction = value
		update_sprite()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_sprite()

func update_sprite() -> void:
	match direction:
		0:
			$sprite.flip_h = true
			$sprite.texture = load("res://sprites/laser/sprLaserStopperRight.png")
		1:
			$sprite.flip_h = false
			$sprite.texture = load("res://sprites/laser/sprLaserStopperRight.png")
		2:
			$sprite.texture = load("res://sprites/laser/sprLaserStopperDown.png")
