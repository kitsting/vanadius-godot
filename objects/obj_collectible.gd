extends Area2D

@export var collectible_name : String
@export var collectible_id : String
@export var savepos : bool = false

var collected : bool = false
var target_body : Node = null

var can_dismiss := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if collectible_id in Game.progress["collectibles"]:
		queue_free()
		
	$collected_screen/ColorRect/name.text = collectible_name
	
	if savepos:
		$sparkle_sprite.modulate = Color.RED

	
func _input(_event: InputEvent) -> void:
	if collected and can_dismiss and Input.is_action_just_pressed("ui_accept"):
		if target_body != null:
			target_body.pstate = target_body.PLAYERSTATE.ALIVE
			Game.progress_append("collectibles", collectible_id)
			
			if savepos:
				Game.roomtargetx = target_body.position.x
				Game.roomtargety = target_body.position.y
				
			Game.save_game()
			
			queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !collected:
		collected = true
		$collected_screen.visible = true
		
		body.pstate = body.PLAYERSTATE.CUTSCENE
		body.direction = Vector2.ZERO
		body.swap_anim("collectible")
		
		global_position.x = body.global_position.x+7
		global_position.y = body.global_position.y-12
		
		z_index = 1
		
		Game.beingchased = false
		
		$sound.play()
		
		target_body = body
		
		await get_tree().create_timer(0.3).timeout
		
		can_dismiss = true


func _on_sparkle_timer_timeout() -> void:
	$sparkle_sprite.position.x = randi_range(-3,3)
	$sparkle_sprite.position.y = randi_range(-3,3)
	
	$sparkle_sprite.play(extstd.choose(["normal", "alternate"]))
	
	$sparkle_timer.start(randf_range(1.0,1.8))
