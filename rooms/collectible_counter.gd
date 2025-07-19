extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !Game.progress.bonus_revealed:
		await get_tree().create_timer(1.5).timeout
		var child_num := 1
		for child in get_children():
			if len(Game.progress.collectibles) >= child_num:
				child.turn_on()
				await get_tree().create_timer(0.3).timeout
				child_num += 1
				Audio.play_sound("res://sounds/sndCollectible.ogg", "light", -3, true, 0.7 + (child_num * 0.02))
				
				
		if len(Game.progress.collectibles) >= get_child_count():
			get_tree().call_group("door", "call_deferred", "lower")
			Game.progress.bonus_revealed = true
