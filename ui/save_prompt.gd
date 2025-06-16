extends CanvasLayer

var delete_mode = true
var confirm = false

signal finished


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Area.text = Game.progress["last_area"]
	%Playtime.text = Game.getTimeString(Game.progress["time_sec"])
	%DeathsNo.text = str(int(Game.progress["deaths"]))
	
	if int(Game.progress["deaths"]) == 1:
		%Deaths.text = "Death"
	
	if !delete_mode:
		%Label.text = "Load this save?"
		%Confirm.text = "Load"
		%Cancel.text = "Do not load"
		
	await get_tree().create_timer(0.05).timeout
	if delete_mode:
		%Cancel.grab_focus()
	else:
		%Confirm.grab_focus()


func is_confirm() -> bool:
	queue_free()
	return confirm


func _on_confirm_pressed() -> void:
	confirm = true
	emit_signal("finished")


func _on_cancel_pressed() -> void:
	confirm = false
	emit_signal("finished")
