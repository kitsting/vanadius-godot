extends CharacterBody2D

var player_node : Node = null


func _ready() -> void:
	Audio.play_sound("res://sounds/sndCloneAppear.ogg", "clone_appear")
	
	player_node = get_tree().get_first_node_in_group("player")
	if player_node != null:
		play_anim(player_node.get_anim(), player_node.is_anim_flipped())
		

func _process(_delta : float) -> void:
	if player_node != null:
		$AnimatedSprite2D.flip_h = player_node.is_anim_flipped()
		
	if Input.is_action_pressed("ui_accept"):
		$ColorRect.visible = true
	else:
		$ColorRect.visible = false



func move(mv_velocity : Vector2) -> void:
	if !Input.is_action_pressed("ui_accept"):
		velocity = mv_velocity
		move_and_slide()
		velocity = Vector2.ZERO

func play_anim(anim : String, flip_h := false) -> void:
	if !Input.is_action_pressed("ui_accept"):
		$AnimatedSprite2D.play(anim)
		$AnimatedSprite2D.flip_h = flip_h
	else:
		var anim_name : String = "idle_" + anim.split("_")[1]
		if $AnimatedSprite2D.sprite_frames.has_animation(anim_name):
			$AnimatedSprite2D.play(anim_name)
		else:
			$AnimatedSprite2D.play(anim)
			$AnimatedSprite2D.flip_h = flip_h


func kill() -> void:
	Audio.play_sound("res://sounds/sndCloneDissappear.ogg", "clone_appear")
	queue_free()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if extstd.match_group(area, ["player", "objLaser", "objSentry", "objSentryMini", "objExplosion", "objGenericSpike", "damage"]):
		kill()
