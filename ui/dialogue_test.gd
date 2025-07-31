extends ColorRect

var pressed := false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept") and !pressed:
		pressed = true
		Game.show_textbox("environmental", "trailer1")
		
		await get_tree().create_timer(5).timeout
		
		Game.show_textbox("environmental", "trailer2")
		
		await get_tree().create_timer(5).timeout
		
		Game.show_textbox("environmental", "trailer3")
		
		await get_tree().create_timer(5).timeout
		
		Game.show_textbox("environmental", "trailer4")
