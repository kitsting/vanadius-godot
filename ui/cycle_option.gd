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

func _ready() -> void:
	$Label.label_settings.font_color = Game.unfocus_color
	
	print(str(Game.options[property])+" in "+str(values)+" : "+str(values.find(Game.options[property])))
	if values.find(Game.options[property]) != -1:
		cycle_position = values.find(Game.options[property])
		$Selection.text = str(keys[cycle_position])
	else:
		$Selection.text = str(keys[0])
		
	update_arrows()
	

func _on_focus_entered() -> void:
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
	if has_focus():
		if Input.is_action_just_pressed("ui_left"):
			if $Selection.text != keys[0]:
				#SoundSystem.play_sound("res://Sounds/UI/UI_Select.wav","ui_battle",-6)
				cycle_position -= 1
				$Selection.text = keys[cycle_position]
				update_arrows()
				Game.option_set(property, values[cycle_position])
		if Input.is_action_just_pressed("ui_right"):
			if $Selection.text != keys.back():
				#SoundSystem.play_sound("res://Sounds/UI/UI_Select.wav","ui_battle",-6)
				cycle_position += 1
				$Selection.text = keys[cycle_position]
				Game.option_set(property, values[cycle_position])
				update_arrows()
