extends AnimatedSprite2D


@export_enum("red", "blue", "green", "yellow") var color = "red"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match color:
		"red":
			modulate = Color.RED
		"blue":
			modulate = Color.BLUE
		"green":
			modulate = Color.GREEN
		"yellow":
			modulate = Color.YELLOW
			
	if Game.progress["pswitch_" + color]:
		animation = "on"
		$AnimationPlayer.play("pulsate")
	else:
		animation = "off"
