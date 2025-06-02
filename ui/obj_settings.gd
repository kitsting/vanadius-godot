extends CanvasLayer

signal done

var submenu = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%VideoBtn.grab_focus()


func exit():
	emit_signal("done")
	queue_free()

func _on_video_btn_pressed() -> void:
	$BG/left_panel.visible = false
	$BG/right_panel/video.visible = true
	submenu = true
	$BG/right_panel/video.get_child(0).grab_focus()
	$BG/NinePatchRect/Label.text = "Video Options"


func _on_audio_btn_pressed() -> void:
	$BG/left_panel.visible = false
	$BG/right_panel/audio.visible = true
	submenu = true
	$BG/right_panel/audio.get_child(0).grab_focus()
	$BG/NinePatchRect/Label.text = "Audio Options"


func _on_access_btn_pressed() -> void:
	$BG/left_panel.visible = false
	$BG/right_panel/accessibility.visible = true
	submenu = true
	$BG/right_panel/accessibility.get_child(0).grab_focus()
	$BG/NinePatchRect/Label.text = "Accessibility Options"
	


func _on_done_pressed() -> void:
	exit()


func _on_video_back_pressed() -> void:
	exit_submenu()
	%VideoBtn.grab_focus()


func _on_audio_back_pressed() -> void:
	exit_submenu()
	%AudioBtn.grab_focus()


func _on_access_back_pressed() -> void:
	exit_submenu()
	%AccessBtn.grab_focus()


func exit_submenu() -> void:
	submenu = false
	$BG/left_panel.visible = true
	$BG/NinePatchRect/Label.text = "Options"
	$BG/right_panel/accessibility.visible = false
	$BG/right_panel/audio.visible = false
	$BG/right_panel/video.visible = false
