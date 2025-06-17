extends CharacterBody2D

var player_node : Node = null


func _ready():
	Audio.play_sound("res://sounds/sndCloneAppear.ogg", "clone_appear")
	
	player_node = get_tree().get_first_node_in_group("player")
	if player_node != null:
		play_anim(player_node.get_anim(), player_node.is_anim_flipped())
		

func _process(delta : float) -> void:
	if player_node != null:
		$AnimatedSprite2D.flip_h = player_node.is_anim_flipped()



func move(mv_velocity : Vector2) -> void:
	if !Input.is_action_pressed("ui_accept"):
		velocity = mv_velocity
		move_and_slide()
		velocity = Vector2.ZERO

func play_anim(anim : String, flip_h := false) -> void:
	$AnimatedSprite2D.flip_h = flip_h
	$AnimatedSprite2D.play(anim)


func kill() -> void:
	Audio.play_sound("res://sounds/sndCloneDissappear.ogg", "clone_appear")
	queue_free()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if extstd.match_group(area, ["player", "objLaser", "objSentry", "objSentryMini", "objExplosion", "objGenericSpike"]):
		kill()
