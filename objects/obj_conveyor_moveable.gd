extends PathFollow2D

@export var spd : float = 0.6

func _ready() -> void:
	rotates = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress += spd * delta * 60
