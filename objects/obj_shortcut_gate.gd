extends StaticBody2D

@export var gate_id : int

var lowered = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if gate_id in Game.progress["gates"]:
		$AnimationPlayer.play("lowered")


func lower() -> void:
	if !lowered:
		lowered = true
		$AnimationPlayer.play("lower")
		Game.progress_append("gates", gate_id)
		await get_tree().create_timer(1.5).timeout
		get_tree().call_group("camera", "shake", 0.5, 30, 2)
