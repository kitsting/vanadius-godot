extends Button


func _ready() -> void:
	$indicator.visible = false


func _on_focus_entered() -> void:
	$indicator.visible = true
	Audio.play_sound("res://sounds/sndPressurePlate.ogg", "menu_enter", 0.0, true, 0.8)


func _on_focus_exited() -> void:
	$indicator.visible = false
