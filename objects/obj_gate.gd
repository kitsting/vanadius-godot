extends StaticBody2D

@onready var down_sprite = preload("res://sprites/gate/sprGateDown.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Game.gatesdeactivated:
		$CollisionShape2D.disabled = true
		$Connector.visible = false
		$Left.sprite = down_sprite
		$CenterL.sprite = down_sprite
		$CenterR.sprite = down_sprite
		$Right.sprite = down_sprite


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
