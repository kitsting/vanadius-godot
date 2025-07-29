extends Control

var animation_playing := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.stats.game_good_ending = true
	
	if Game.progress.time_sec < Game.stats.best_time_sec:
		Game.stats.best_time_sec = Game.progress.time_sec
		
	if Game.progress.deaths < Game.stats.best_deaths:
		Game.stats.best_deaths = Game.progress.deaths
		
	Game.save_game()
	
	$Control/stats/time/quote_text.text = Game.getTimeString(Game.progress.time_sec)
	$Control/stats/deaths/quote_text.text = str(Game.progress.deaths)
	$Control/stats/collectibles/quote_text.text = str(len(Game.progress.collectibles))+"/19"
	Audio.stop_music(1, 2)
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.play("ending")
	await $AnimationPlayer.animation_finished
	animation_playing = false
	
	
func _input(event : InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept") and !animation_playing:
		animation_playing = true
		Game.transition_room("res://ui/obj_title.tscn")
