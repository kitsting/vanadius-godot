extends Button


func _ready() -> void:
	$indicator.visible = false


func _on_focus_entered() -> void:
	$indicator.visible = true
	$sound.play()


func _on_focus_exited() -> void:
	$indicator.visible = false
