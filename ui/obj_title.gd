extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%VersionNo.text = Game.version
	
	Game.stop_playing()
	Game.stop_clock_timer()
	
	if !Game.file_loaded:
		$Options/Resume.queue_free()
	
	await get_tree().create_timer(0.3).timeout
	$Options.get_child(0).grab_focus()
	
	#Option wrap around
	%Quit.focus_neighbor_bottom = %Quit.get_path_to($Options.get_child(0))
	$Options.get_child(0).focus_neighbor_top = $Options.get_child(0).get_path_to(%Quit)
	
	Audio.set_music("res://music/"+Game.getMusic(Game.area)+".ogg")
	
	#Do some loading here to not mess with debugging
	Game.area = Game.progress["last_area"]
	Game.roomtargetx = Game.progress["last_room_x"]
	Game.roomtargety = Game.progress["last_room_y"]
	Game.roomtargetfacing = Game.progress["last_room_dir"]
	Game.roomtargetstate = Game.progress["last_room_state"]

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	var new_settings = load("res://ui/objSettings.tscn").instantiate()
	add_sibling(new_settings)
	await new_settings.done
	await get_tree().create_timer(0.05).timeout
	$Options/Options.grab_focus()


func _on_new_game_pressed() -> void:
	var confirm_prompt = load("res://ui/save_prompt.tscn").instantiate()
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


func _on_resume_pressed() -> void:
	var confirm_prompt = load("res://ui/save_prompt.tscn").instantiate()
	confirm_prompt.delete_mode = false
	add_sibling(confirm_prompt)
	await confirm_prompt.finished
	
	if confirm_prompt.is_confirm():
		Game.transition_room(Game.progress["last_room"])
	else:
		await get_tree().create_timer(0.05).timeout
		%Resume.grab_focus()
