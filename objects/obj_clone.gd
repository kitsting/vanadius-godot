extends CharacterBody2D

func move(mv_velocity : Vector2) -> void:
	velocity = mv_velocity
	move_and_slide()
	velocity = Vector2.ZERO
