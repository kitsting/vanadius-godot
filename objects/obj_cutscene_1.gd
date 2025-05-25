extends Area2D

@export var state : Game.PLAYERSTATE = Game.PLAYERSTATE.CUTSCENE
@export var destroy_on_touch = false

var touched = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.pstate = state
		body.dir = Game.PLAYERDIR.RIGHT
		body.swap_anim("idle_right")
		
		if destroy_on_touch:
			queue_free()
