@tool
extends RichTextEffect
class_name RichTextVoid

var bbcode := "void"

func _process_custom_fx(char_fx):
	var movex := randi_range(-1, 1)
	var movey := randi_range(-1, 1)
	if randi_range(0, 100) == 0:
		char_fx.offset = Vector2(movex, movey)
	
	return true
