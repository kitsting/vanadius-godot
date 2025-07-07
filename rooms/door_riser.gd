extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !Game.progress.deeplab_complete:
		get_tree().call_group("door", "call_deferred", "rise")
