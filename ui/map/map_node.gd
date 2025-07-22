@tool
extends TextureRect

enum AREAS {
	CAVE,
	RUIN,
	FACTORY,
	LAB,
	DEEPLAB,
	CLOCK,
	POWER,
	OUTSIDE,
	SPECIAL
}

var colors := {
	AREAS.CAVE : "#4c4c8c",
	AREAS.RUIN : "#595652",
	AREAS.FACTORY : "#415c28",
	AREAS.LAB : "#874b9e",
	AREAS.DEEPLAB : "#453b41",
	AREAS.CLOCK : "#8f563b",
	AREAS.POWER : "#306082",
	AREAS.OUTSIDE : "#a4915d",
	AREAS.SPECIAL : "#ad4444",
}

@export var area := AREAS.CAVE:
	set(value):
		area = value
		self_modulate = colors[area]


@export var room_id := ""


func _ready() -> void:
	self_modulate = colors[area]
	
	if !Engine.is_editor_hint():
		$you_are_here.visible = false
		$you_are_here.size = size+Vector2(2,2)
		
		if !room_id in Game.progress.visited_rooms:
			queue_free()
			
		if room_id == Game.current_room:
			# Center map on current room
			get_parent().get_parent().move_position(position)
			
			$you_are_here.visible = true
