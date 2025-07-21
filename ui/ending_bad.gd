extends Control

var quote : String = ""

var can_input := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Game.progress.time_sec < 20*60:
		quote = "\"You walked the speedy path, yet the outcome was the same. Curious...\""
	elif Game.stats.game_good_ending:
		quote = "\"You've found freedom, yet you still choose the forsaken path? Interesting...\""
	elif len(Game.progress.collectibles) < 15:
		quote = "\"There must be a better ending. Perhaps if you gathered more [color=sky_blue]Collectibles[/color]?\""
	elif len(Game.progress.collectibles) >= 15 and !Game.progress.bonus_revealed:
		quote = "\"There must be a better ending. Perhaps you can find a use for the [color=sky_blue]Collectibles[/color] you've gathered...\""
	elif len(Game.progress.collectibles) >= 15 and Game.progress.bonus_revealed:
		quote = "\"There must be a better ending. Perhaps with a bit more exploration...\""
	else:
		quote = "\"Well done. Few have made it this far.\""
		
	$quote/quote_text.text = quote
	
	$AnimationPlayer.play("play_ending")
	await $AnimationPlayer.animation_finished
	can_input = true


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept") and can_input:
		Game.transition_room("res://ui/obj_title.tscn")
