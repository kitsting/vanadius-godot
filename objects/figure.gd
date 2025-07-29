extends Sprite2D


func _ready() -> void:
	if Game.progress.figure_seen:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	Game.progress.figure_seen = true
	var tween := create_tween().tween_property(self, "modulate", Color(1,1,1,0), 0.5)
	await tween.finished
	queue_free()
