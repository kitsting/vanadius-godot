extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("show")


func set_area_name(new_name : String) -> void:
	$Label.text = new_name


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
