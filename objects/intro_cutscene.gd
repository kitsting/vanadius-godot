extends Area2D

@export var platform_node : Node = null
@export var player_node : Node = null
@export var tutorial_node : Node = null

var active := false


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") and !active:
		active = true
		cutscene()


func cutscene() -> void:
	if tutorial_node != null:
		tutorial_node.modulate.a = 0
		Audio.stop_music()
	platform_node.position.y = position.y
	player_node.position = platform_node.position
	platform_node.target_body = player_node

	await platform_node.tippy_top
	
	if tutorial_node != null:
		Audio.resume_music()
	
	if player_node.pstate == Game.PLAYERSTATE.CUTSCENE:
		player_node.swap_anim("dead", false, true)
	
	await get_tree().create_timer(0.5).timeout
	
	if player_node.pstate == Game.PLAYERSTATE.CUTSCENE:
		player_node.pstate = Game.PLAYERSTATE.ALIVE

	if tutorial_node != null:
		var tween := get_tree().create_tween()
		tween.tween_property(tutorial_node, "modulate", Color(1,1,1,1), 0.5)
