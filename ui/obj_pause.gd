extends CanvasLayer

signal done

var map_mode : bool = false
var can_input : bool = true
var settings := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_input()
	Game.connect("device_changed", update_input)
	
	if Game.progress.bonus_revealed:
		%collect_label.text = str(Game.progress["collectibles"].size()) + "/19"
	elif Game.progress.power_complete:
		%collect_label.text = str(Game.progress["collectibles"].size()) + "/" + str(Game.m_total_collectibles)
	else:
		%collect_label.text = str(Game.progress["collectibles"].size())
	%death_label.text = str(int(Game.progress["deaths"]))
	
	%Resume.grab_focus()
	
	
func _input(_event: InputEvent) -> void:
	update_input()
	
	if (Input.is_action_just_pressed("pause") or Input.is_action_just_pressed("ui_cancel")) and !settings:
		exit()
		
	if Input.is_action_just_pressed("map") and can_input:
		if !map_mode:
			map_mode = true
			%objMap.can_input = true
			can_input = false
			$AnimationPlayer.play("show_map")
			await $AnimationPlayer.animation_finished
			can_input = true
		else:
			map_mode = false
			can_input = false
			%objMap.can_input = false
			$AnimationPlayer.play_backwards("show_map")
			await $AnimationPlayer.animation_finished
			%Resume.grab_focus()
			can_input = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	%time_label.text = Game.getTimeString(Game.progress["time_sec"])


func exit() -> void:
	emit_signal("done")
	queue_free()


func _on_resume_pressed() -> void:
	if can_input and !map_mode:
		exit()


func _on_options_pressed() -> void:
	settings = true
	can_input = false
	var new_settings : Node = load("res://ui/objSettings.tscn").instantiate()
	add_sibling(new_settings)
	await new_settings.done
	await get_tree().create_timer(0.1).timeout
	settings = false
	can_input = true
	%Options.grab_focus()


func _on_quit_pressed() -> void:
	Game.transition_room("res://ui/obj_title.tscn")
	
	
func update_input() -> void:
	if Game.current_device == InputHelper.DEVICE_KEYBOARD:
		$BG/NinePatchRect/ColorRect/map_mode/TextureKeyboard.visible = true
		$BG/NinePatchRect/ColorRect/map_mode/TextureGamepad.visible = false
	else:
		$BG/NinePatchRect/ColorRect/map_mode/TextureKeyboard.visible = false
		$BG/NinePatchRect/ColorRect/map_mode/TextureGamepad.visible = true
