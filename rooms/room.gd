extends Node2D

@export_enum(
	Game.m_area_ruin,
	Game.m_area_cave,
	Game.m_area_ruin_sub2,
	Game.m_area_lab,
	Game.m_area_deeplab,
	Game.m_area_clock,
	Game.m_area_clock_sub1,
	Game.m_area_clock_sub2,
	Game.m_area_factory,
	Game.m_area_final,
	Game.m_area_final_sub2,
	Game.m_area_final_sub3,
	Game.m_area_outside) var area : String = Game.m_area_cave
@export var room_name : String = ""
@export var internal_name : String = ""

@export var silent : bool = false
@export var beep_boop_room : bool = false
@export var allow_pausing : bool = true
@export var suppress_area_display := false
@export var music := ""

@export_group("Darkness")
@export_range(0.0, 1.0, 0.05) var darkness_intensity : float = 0:
	set(value):
		darkness_intensity = value
		if is_ready: update_darkness()
@export_range(0.0, 1.0, 0.05) var darkness_light : float = 1:
	set(value):
		darkness_light = value
		if is_ready: update_darkness()

#Override the radius of all sentries in the room
@export_group("Sentry Override")
@export var override_sentry_radius : int = 0
@export var override_mini_sentry_radius : int = 0

@export_group("Screen Settings")
@export var single_screen_vertical : bool = false
@export var single_screen_horizontal : bool = false

var pause_cooldown : bool = false

var is_ready := false



func _init() -> void:
	add_to_group("room")


func _ready() -> void:
	Game.currentroom = internal_name
	
	if area == Game.m_area_final and Game.progress.power_complete == false:
		darkness_intensity = 0.4
		darkness_light = 0.5
	
	Game.lasers = true
	
	if !suppress_area_display:
		if Game.area != area and room_name == "":
			var area_display : Node = load("res://ui/area_display.tscn").instantiate()
			area_display.set_area_name(area)
			add_child(area_display)
			
		if room_name != "":
			var area_display : Node = load("res://ui/area_display.tscn").instantiate()
			area_display.set_area_name(room_name)
			add_child(area_display)
	
	Game.area = area
	
	Game.progress_append("visited_rooms", internal_name)
	
	Game.set_playing()
	
	if Game.progress.towertime_left > -1:
		Game.start_clock_timer()
	
	if override_sentry_radius != 0:
		get_tree().call_group("objSentry","@radius_setter",override_sentry_radius)
		
	if override_mini_sentry_radius != 0:
		get_tree().call_group("objSentryMini","@radius_setter",override_mini_sentry_radius)
		
	update_darkness()
		
	
	#Get the size of the current room and lock the camera
	var room_size : Rect2 = $Floor.get_used_rect()
	
	#Set camera limit to size of room - 1 (to prevent seeing tile borders)
	if has_node("Camera"):
		$Camera.limit_bottom = (room_size.end.y*24) - 1
		$Camera.limit_right = (room_size.end.x*24) - 1
		$Camera.limit_top = (room_size.position.y*24) + 1
		$Camera.limit_left = room_size.position.x*24 + 1
		
		if single_screen_vertical:
			$Camera.limit_left = room_size.position.x*24 + 8
			$Camera.limit_right = (room_size.end.x*24) - 8
			
		if single_screen_horizontal:
			$Camera.limit_top = (room_size.position.y*24) + 6
			$Camera.limit_bottom = (room_size.end.y*24) - 6
		
	if !silent:
		if beep_boop_room:
			Audio.set_music("res://music/mysterious.ogg")
		else:
			if music == "":
				Audio.set_music("res://music/"+Game.getMusic(area)+".ogg")
			else:
				Audio.set_music("res://music/"+music+".ogg")
	else:
		if beep_boop_room and Game.progress.power_complete:
			Audio.set_music("res://music/mysterious.ogg")
		else:
			Audio.stop_music()
		
	get_tree().call_group("player", "set_state", Game.roomtargetstate)
	get_tree().call_group("player","set_pos_facing",Game.roomtargetx,Game.roomtargety,Game.roomtargetfacing)
	
	Game.current_room = internal_name
	
	is_ready = true


func checkArea() -> String:
	return area


func _input(_event: InputEvent) -> void:
	if allow_pausing and Input.is_action_just_pressed("pause") and !pause_cooldown:
		var new_pause : Node = load("res://ui/objPause.tscn").instantiate()
		Game.pause_screen = true
		get_tree().paused = true
		add_child(new_pause)
		pause_cooldown = true
		await new_pause.done
		get_tree().paused = false
		Game.pause_screen = false
		await get_tree().create_timer(0.2).timeout
		pause_cooldown = false


func set_pausable(pausable := true) -> void:
	allow_pausing = pausable


func turn_on_lights() -> void:
	print("turning on lights")
	var tween := create_tween()
	tween.tween_property(self, "darkness_intensity", 0, 1)
	tween.tween_property(self, "darkness_light", 0, 1)


func update_darkness() -> void:
	$darkness.color = Color(1-darkness_intensity, 1-darkness_intensity, 1-darkness_intensity)
	get_tree().call_group("player", "set_flashlight", darkness_intensity, darkness_light)
