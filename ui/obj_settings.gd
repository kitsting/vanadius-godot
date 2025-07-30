extends CanvasLayer

signal done

var submenu := false
var last_button : Node = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%VideoBtn.grab_focus()
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause") or Input.is_action_just_pressed("ui_cancel"):
		if !submenu:
			exit()
		else:
			exit_submenu()
			last_button.grab_focus()


func exit() -> void:
	emit_signal("done")
	Audio.play_sound("res://sounds/sndPressurePlate.ogg", "menu", 0.0, true, 0.6)
	Audio.block_channel("menu_enter", 0.1)
	queue_free()

func _on_video_btn_pressed() -> void:
	$BG/left_panel.visible = false
	$BG/right_panel/video.visible = true
	submenu = true
	last_button = %VideoBtn
	$BG/right_panel/video.get_child(0).grab_focus()
	$BG/NinePatchRect/Label.text = "Video Settings"


func _on_audio_btn_pressed() -> void:
	$BG/left_panel.visible = false
	$BG/right_panel/audio.visible = true
	submenu = true
	last_button = %AudioBtn
	$BG/right_panel/audio.get_child(0).grab_focus()
	$BG/NinePatchRect/Label.text = "Audio Settings"


func _on_access_btn_pressed() -> void:
	$BG/left_panel.visible = false
	$BG/right_panel/accessibility.visible = true
	submenu = true
	last_button = %AccessBtn
	$BG/right_panel/accessibility.get_child(0).grab_focus()
	$BG/NinePatchRect/Label.text = "Accessibility Settings"
	


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
	Audio.play_sound("res://sounds/sndPressurePlate.ogg", "menu", 0.0, true, 0.6)
	Audio.block_channel("menu_enter", 0.1)
	
func backbutton_focus() -> void:
	Audio.play_sound("res://sounds/sndPressurePlate.ogg", "menu_enter", 0.0, true, 0.8)
