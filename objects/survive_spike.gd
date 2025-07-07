extends Node2D

func _ready() -> void:
	spike_in()
	

func extend(time := 8.0) -> void:
	call_deferred("animate", time)
	

func animate(time := 8.0) -> void:
	spike_out()
	Audio.play_sound("res://sounds/sndRetractingSpike.ogg", "survive")
	
	await get_tree().create_timer(time).timeout
	
	spike_in()
	
	
func spike_out() -> void:
	$AnimatedSprite2D.animation = "up"
	$Area/CollisionShape2D.disabled = false
	
func spike_in() -> void:
	$AnimatedSprite2D.animation = "down"
	$Area/CollisionShape2D.disabled = true
	
