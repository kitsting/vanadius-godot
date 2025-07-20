extends StaticBody2D

@onready var down_sprite = preload("res://sprites/gate/sprGateDown.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Game.progress["gates_down"]:
		$CollisionShape2D.disabled = true
		$Connector.visible = false
		$Left.texture = down_sprite
		$CenterL.texture = down_sprite
		$CenterR.texture = down_sprite
		$Right.texture = down_sprite
		z_index = -1
