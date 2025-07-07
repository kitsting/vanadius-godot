@tool
extends HBoxContainer

@export var label = "Label:":
	set(new_label):
		$Label.text = new_label
		
		label = new_label
	get:
		return label
		
@export var property = "controller_prompts"

@export var keys : Array[String]
@export var values : Array

var cycle_position = 0
var lockout = false

func _ready() -> void:
	$Label.label_settings.font_color = Game.unfocus_color
	
	if !Engine.is_editor_hint():
		print(str(Game.options[property])+" in "+str(values)+" : "+str(values.find(Game.options[property])))
		if values.find(Game.options[property]) != -1:
			cycle_position = values.find(Game.options[property])
			$Selection.text = str(keys[cycle_position])
		else:
			$Selection.text = str(keys[0])
		
	update_arrows()
	

func _on_focus_entered() -> void:
	Audio.play_sound("res://sounds/sndPressurePlate.ogg", "menu_enter", 0.0, true, 0.8)
	$Label.label_settings.font_color = Game.focus_color


func _on_focus_exited() -> void:
	$Label.label_settings.font_color = Game.unfocus_color
	
	
func update_arrows():
	if keys[0] == $Selection.text:
		$LeftArrow.modulate.a = 0.1
	else:
		$LeftArrow.modulate.a = 1
		
	if keys.back() == $Selection.text:
		$RightArrow.modulate.a = 0.1
	else:
		$RightArrow.modulate.a = 1
		
		
func _input(event):
	if has_focus() and !lockout:
		if Input.is_action_just_pressed("ui_left"):
			try_lockout()
			if $Selection.text != keys[0]:
				cycle_position -= 1
				$Selection.text = keys[cycle_position]
				update_arrows()
				Game.option_set(property, values[cycle_position])
				Audio.play_sound("res://sounds/sndPressurePlate.ogg", "menu", 0.0, true, 1.0)
				
		if Input.is_action_just_pressed("ui_right"):
			try_lockout()
			if $Selection.text != keys.back():
				cycle_position += 1
				$Selection.text = keys[cycle_position]
				Game.option_set(property, values[cycle_position])
				update_arrows()
				Audio.play_sound("res://sounds/sndPressurePlate.ogg", "menu", 0.0, true, 1.0)


# Very brief input lockout to prevent double inputs
func try_lockout():
	lockout = true
	await get_tree().create_timer(0.05).timeout
	lockout = false
