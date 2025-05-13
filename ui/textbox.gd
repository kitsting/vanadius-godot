extends CanvasLayer

signal text_finished

var can_dismiss := false
var can_skip := false

var dialogue_resource := preload("res://resources/dialogue/test.dialogue")
var dialogue_line : DialogueLine

func set_text(file : String = "test", node : String = "test_text"):
	dialogue_resource = load("res://resources/dialogue/"+file+".dialogue")
	dialogue_line = await dialogue_resource.get_next_dialogue_line(node)
	$BG/Label.dialogue_line = dialogue_line
	
	

func _ready():
	$next.visible = false
	$last.visible = false
	
	$BG/Label.type_out()
	await $BG/Label.finished_typing
	can_dismiss = true

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		if can_dismiss:
			#Go to next line
			if dialogue_line != null:
				can_dismiss = false
				$DismissCooldown.start(0.15)
				can_skip = false
				$next.visible = false
				$last.visible = false
				$BG/Label.dialogue_line = dialogue_line
				$BG/Label.type_out()
				await $BG/Label.finished_typing
				can_dismiss = true
			else:
				emit_signal("text_finished")
				queue_free()
		if can_skip:
			$BG/Label.skip_typing()

func _on_dismiss_cooldown_timeout():
	can_skip = true


func _on_label_finished_typing() -> void:
	dialogue_line = await dialogue_resource.get_next_dialogue_line(dialogue_line.next_id)
	
	#var line = dialogue_line.next_id
	#print(line)
	#
	if dialogue_line == null:
		$last.visible = true
	else:
		$next.visible = true
