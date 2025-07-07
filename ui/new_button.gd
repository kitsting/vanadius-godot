extends Button



func _on_focus_entered() -> void:
	Audio.play_sound("res://sounds/sndPressurePlate.ogg", "menu_enter", 0.0, true, 0.8)


func _on_pressed() -> void:
	Audio.play_sound("res://sounds/sndPressurePlate.ogg", "menu", 0.0, true, 1.0)
	Audio.block_channel("menu_enter", 0.1)
