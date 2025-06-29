extends Node2D

func set_angle(angle : Vector2):
	rotation = angle.angle() + deg_to_rad(90)



func _on_bounce_anim_animation_finished() -> void:
	queue_free()
