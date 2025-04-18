extends Node2D

@export var silent : bool = false

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

#Override the radius of all sentries in the room
@export var override_sentry_radius : int = 0
@export var override_mini_sentry_radius : int = 0


func _init() -> void:
	add_to_group("room")

func _ready() -> void:
	if override_sentry_radius != 0:
		get_tree().call_group("objSentry","set_radius",override_sentry_radius)
		
	if override_mini_sentry_radius != 0:
		get_tree().call_group("objSentryMini","set_radius",override_mini_sentry_radius)

func checkArea():
	return area
