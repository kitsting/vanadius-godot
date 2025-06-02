extends CanvasLayer

signal done

var map_mode : bool = false
var can_input : bool = true
var settings := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%collect_label.text = str(Game.collectibles.size()) + "/" + str(Game.m_total_collectibles)
	%death_label.text = str(Game.deaths)
	
	%Resume.grab_focus()
	
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause") and !settings:
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
func _process(delta: float) -> void:
	%time_label.text = Game.getTimeString(Game.timeplayedseconds)


func exit():
	emit_signal("done")
	queue_free()


func _on_resume_pressed() -> void:
	if can_input and !map_mode:
		exit()


func _on_options_pressed() -> void:
	settings = true
	can_input = false
	var new_settings = load("res://ui/objSettings.tscn").instantiate()
	add_sibling(new_settings)
	await new_settings.done
	await get_tree().create_timer(0.1).timeout
	settings = false
	can_input = true
	%Options.grab_focus()
