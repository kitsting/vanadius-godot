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

@export var silent : bool = false
@export var darkness_intensity : float = 0
@export var darkness_light : float = 0

#Override the radius of all sentries in the room
@export var override_sentry_radius : int = 0
@export var override_mini_sentry_radius : int = 0


func _init() -> void:
	add_to_group("room")

func _ready() -> void:
	if override_sentry_radius != 0:
		get_tree().call_group("objSentry","@radius_setter",override_sentry_radius)
		
	if override_mini_sentry_radius != 0:
		get_tree().call_group("objSentryMini","@radius_setter",override_mini_sentry_radius)
		
	
	#Get the size ofthe current room and lock the camera
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
		
	Game.alert = false
	Game.beingchased = false

func checkArea():
	return area
