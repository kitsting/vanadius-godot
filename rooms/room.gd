extends Node2D

@export_enum(
	Game.m_area_ruin,
	Game.m_area_ruin_sub1,
	Game.m_area_cave,
	Game.m_area_ruin_sub2,
	Game.m_area_ruin_sub3,
	Game.m_area_ruin_sub4,
	Game.m_area_lab,
	Game.m_area_deeplab,
	Game.m_area_clock,
	Game.m_area_clock_sub1,
	Game.m_area_clock_sub2,
	Game.m_area_factory,
	Game.m_area_factory_sub1,
	Game.m_area_final,
	Game.m_area_final_sub1,
	Game.m_area_final_sub2,
	Game.m_area_final_sub3,
	Game.m_area_outside) var area : String = Game.m_area_cave
@export var room_name : String = ""
@export var internal_name : String = ""

@export var silent : bool = false
@export var allow_pausing : bool = true
@export_range(0.0, 1.0, 0.05) var darkness_intensity : float = 0
@export_range(0.0, 1.0, 0.05) var darkness_light : float = 1

#Override the radius of all sentries in the room
@export var override_sentry_radius : int = 0
@export var override_mini_sentry_radius : int = 0

var pause_cooldown : bool = false


func _init() -> void:
	add_to_group("room")


func _ready() -> void:
	if has_node("darkness"):
		$darkness.color = Color(1-darkness_intensity, 1-darkness_intensity, 1-darkness_intensity)
	
	Game.lasers = true
	Game.area = area
	
	Game.set_playing()
	
	if override_sentry_radius != 0:
		get_tree().call_group("objSentry","@radius_setter",override_sentry_radius)
		
	if override_mini_sentry_radius != 0:
		get_tree().call_group("objSentryMini","@radius_setter",override_mini_sentry_radius)
		
	get_tree().call_group("player", "set_flashlight", darkness_intensity, darkness_light)
		
	
	#Get the size of the current room and lock the camera
	var room_size = $Floor.get_used_rect()
	
	if has_node("Camera"):
		$Camera.limit_bottom = (room_size.end.y*24) - 1
		$Camera.limit_right = (room_size.end.x*24)
		$Camera.limit_top = (room_size.position.y*24) + 1
		$Camera.limit_left = room_size.position.x*24
		
	if !silent:
		Audio.set_music("res://music/"+Game.getMusic(area)+".ogg")
	else:
		Audio.stop_music()
		
	get_tree().call_group("player", "set_state", Game.roomtargetstate)
	get_tree().call_group("player","set_pos_facing",Game.roomtargetx,Game.roomtargety,Game.roomtargetfacing)
	
	Game.current_room = internal_name

func checkArea():
	return area


func _input(event: InputEvent) -> void:
	if allow_pausing and Input.is_action_just_pressed("pause") and !pause_cooldown:
		var new_pause = load("res://ui/objPause.tscn").instantiate()
		get_tree().paused = true
		add_child(new_pause)
		pause_cooldown = true
		await new_pause.done
		get_tree().paused = false
		await get_tree().create_timer(0.2).timeout
		pause_cooldown = false


func set_pausable(pausable := true):
	allow_pausing = pausable
