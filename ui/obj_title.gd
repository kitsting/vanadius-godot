extends Control

var showing_credits = false

var line : int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%VersionNo.text = Game.version
	
	Game.stop_playing()
	Game.stop_clock_timer()
	
	if !Game.file_loaded:
		$Options/Resume.queue_free()
		%NewGame.grab_focus()
		
		#Option wrap around
		%Quit.focus_neighbor_bottom = %Quit.get_path_to(%NewGame)
		%NewGame.focus_neighbor_top = $Options.get_child(0).get_path_to(%Quit)
	else:
		%Resume.grab_focus()
		
		#Option wrap around
		%Quit.focus_neighbor_bottom = %Quit.get_path_to(%Resume)
		%Resume.focus_neighbor_top = $Options.get_child(0).get_path_to(%Quit)

	
	#Do some loading here to not mess with debugging
	Game.area = Game.progress["last_area"]
	Game.roomtargetx = Game.progress["last_room_x"]
	Game.roomtargety = Game.progress["last_room_y"]
	Game.roomtargetfacing = Game.progress["last_room_dir"]
	Game.roomtargetstate = Game.progress["last_room_state"]
	
	
	Audio.set_music("res://music/"+Game.getMusic(Game.area)+".ogg")
	
	match Game.area:
		Game.m_area_cave:
			$BackgroundH.texture.viewport_path = $Views/Cave.get_path()
		Game.m_area_clock, Game.m_area_clock_sub1, Game.m_area_clock_sub2:
			$BackgroundV.visible = true
			$BackgroundH.visible = false
		Game.m_area_lab, Game.m_area_deeplab:
			$BackgroundH.texture.viewport_path = $Views/Lab.get_path()
		Game.m_area_factory:
			$BackgroundH.texture.viewport_path = $Views/Factory.get_path()
		Game.m_area_final, Game.m_area_final_sub3:
			$BackgroundH.texture.viewport_path = $Views/Power.get_path()
		Game.m_area_final_sub2, Game.m_area_outside:
			$OutsideBG.visible = true
			$BackgroundH.visible = false
			

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	var new_settings : Node = load("res://ui/objSettings.tscn").instantiate()
	add_sibling(new_settings)
	await new_settings.done
	await get_tree().create_timer(0.05).timeout
	$Options/Options.grab_focus()


func _on_new_game_pressed() -> void:
	if Game.file_loaded:
		var confirm_prompt : Node = load("res://ui/save_prompt.tscn").instantiate()
		confirm_prompt.delete_mode = true
		add_sibling(confirm_prompt)
		await confirm_prompt.finished
		
		if confirm_prompt.is_confirm():
			Game.reset()
			Game.roomtargetstate = Game.PLAYERSTATE.CUTSCENE
			Game.progress_set("last_room", "res://rooms/rmIntro.tscn")
			Game.transition_room("res://rooms/rmIntro.tscn")
		else:
			await get_tree().create_timer(0.05).timeout
			%NewGame.grab_focus()
	else:
		Game.reset()
		Game.roomtargetstate = Game.PLAYERSTATE.CUTSCENE
		Game.progress_set("last_room", "res://rooms/rmIntro.tscn")
		Game.transition_room("res://rooms/rmIntro.tscn")


func _on_resume_pressed() -> void:
	var confirm_prompt : Node = load("res://ui/save_prompt.tscn").instantiate()
	confirm_prompt.delete_mode = false
	add_sibling(confirm_prompt)
	await confirm_prompt.finished
	
	if confirm_prompt.is_confirm():
		Game.transition_room(Game.progress["last_room"])
	else:
		await get_tree().create_timer(0.05).timeout
		%Resume.grab_focus()


func _on_credits_pressed() -> void:
	if !showing_credits:
		showing_credits = true
		$Credits.visible = true
		$Credits/MarginContainer/Label.scroll_to_line(0)
		$Credits/MarginContainer/Label.grab_focus()
	
func _input(event: InputEvent) -> void:
	if showing_credits:
		if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("ui_accept"):
			$Credits.visible = false
			await get_tree().create_timer(0.1).timeout
			$Options/Credits.grab_focus()
			showing_credits = false
			
		if Input.is_action_just_pressed("ui_up"):
			line = clamp(line - 2, 0, $Credits/MarginContainer/Label.get_visible_line_count()+2)
			
		if Input.is_action_just_pressed("ui_down"):
			line = clamp(line + 2, 0, $Credits/MarginContainer/Label.get_visible_line_count()+2)
			
		$Credits/MarginContainer/Label.scroll_to_line(line)
