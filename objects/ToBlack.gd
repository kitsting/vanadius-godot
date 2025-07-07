extends CanvasLayer

signal midpoint
signal done

var speed : float = 1.0
var wait : float = 0.0


func _ready() -> void:
	$AnimationPlayer.play("FadeIn",-1,speed)


func _on_AnimationPlayer_animation_finished(anim_name : String) -> void:
	if anim_name == "FadeIn":
		emit_signal("midpoint")
		if wait > 0:
			await get_tree().create_timer(wait).timeout
		$AnimationPlayer.play("FadeOut",-1,speed)
	elif anim_name == "FadeOut":
		emit_signal("done")
		queue_free()


func set_speed(new_speed : float) -> void:
	speed = new_speed
	
func set_wait(new_wait : float) -> void:
	wait = new_wait
