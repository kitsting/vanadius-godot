extends Area2D

@export var state : Game.PLAYERSTATE = Game.PLAYERSTATE.CUTSCENE
@export var destroy_on_touch := false

var touched := false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.pstate = state
		body.dir = Game.PLAYERDIR.RIGHT
		body.swap_anim("idle_right")
		
		if destroy_on_touch:
			queue_free()
