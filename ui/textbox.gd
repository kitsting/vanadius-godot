extends CanvasLayer

signal text_finished

var can_dismiss := false
var can_skip := false

var choice_selection := false

var dialogue_resource := preload("res://resources/dialogue/test.dialogue")
var dialogue_line : DialogueLine

var next_id_1 = null
var next_id_2 = null



func set_text(file : String = "test", node : String = "test_text"):
	dialogue_resource = load("res://resources/dialogue/"+file+".dialogue")
	dialogue_line = await dialogue_resource.get_next_dialogue_line(node)
	$BG/Label.dialogue_line = dialogue_line
	
	

func _ready():
	Audio.play_sound("res://sounds/sndBeep.ogg", "beep")
	$next.visible = false
	$last.visible = false
	$option_BG.visible = false
	
	$BG/Label.type_out()
	await $BG/Label.finished_typing
	can_dismiss = true

func _input(event):
	if Input.is_action_just_pressed("ui_accept") and !$option_BG.visible:
		if can_dismiss:
			#Go to next line
			if dialogue_line != null:
				advance_text()
			else:
				Audio.play_sound("res://sounds/sndBeep.ogg", "beep", 0, false, 0.9)
				emit_signal("text_finished")
				queue_free()
		if can_skip:
			$BG/Label.skip_typing()


func _on_dismiss_cooldown_timeout():
	can_skip = true


func _on_label_finished_typing() -> void:
	if dialogue_line.responses == []:
		dialogue_line = await dialogue_resource.get_next_dialogue_line(dialogue_line.next_id)
		
		#var line = dialogue_line.next_id
		#print(line)
		#
		if dialogue_line == null:
			$last.visible = true
		else:
			$next.visible = true
	else:
		populate_choices()
		$option_BG.visible = true


func _on_label_spoke(letter: String, letter_index: int, speed: float) -> void:
	$text_sound.pitch_scale = randf_range(0.9,1.1)
	$text_sound.play()
	
	
func populate_choices():
	if len(dialogue_line.responses) >= 2:
		$option_BG/hbox/option1.text = dialogue_line.responses[0].text
		next_id_1 = dialogue_line.responses[0].next_id
		$option_BG/hbox/option2.text = dialogue_line.responses[1].text
		next_id_2 = dialogue_line.responses[1].next_id
		$option_BG.visible = true
		await get_tree().create_timer(0.5).timeout
		$option_BG/hbox/option1.grab_focus()


func _on_option_1_pressed() -> void:
	$option_BG.visible = false
	dialogue_line = await dialogue_resource.get_next_dialogue_line(next_id_1)
	advance_text()

func _on_option_2_pressed() -> void:
	$option_BG.visible = false
	dialogue_line = await dialogue_resource.get_next_dialogue_line(next_id_2)
	advance_text()


func advance_text():
	Audio.play_sound("res://sounds/sndBeep.ogg", "beep")
	can_dismiss = false
	$DismissCooldown.start(0.15)
	can_skip = false
	$next.visible = false
	$last.visible = false
	$BG/Label.dialogue_line = dialogue_line
	$BG/Label.type_out()
	await $BG/Label.finished_typing
	can_dismiss = true
