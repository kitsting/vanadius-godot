extends StaticBody2D

@export_enum("red", "blue", "green", "yellow") var color = "red"

var can_read := false
var target_body : Node = null
var interactable := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$interact_sprite.play("use")
	
	match color:
		"red":
			$crystal.modulate = Color.RED
		"blue":
			$crystal.modulate = Color.BLUE
		"green":
			$crystal.modulate = Color.GREEN
		"yellow":
			$crystal.modulate = Color.YELLOW
			
	if Game.progress["pswitch_" + color]:
		$AnimationPlayer.play("pulsate")
		interactable = false
	else:
		$AnimationPlayer.play("off")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "turn_on":
		$AnimationPlayer.play("pulsate")
		

func _input(event: InputEvent) -> void:
	if can_read and interactable and Input.is_action_just_pressed("ui_accept"):
		if target_body.pstate == target_body.PLAYERSTATE.ALIVE:
			Game.progress["pswitch_" + color] = true
			interactable = false
			$AnimationPlayer.play("turn_on")
			Audio.play_sound("res://sounds/sndCrystal.ogg", "crystal")


func _on_interact_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and interactable:
		can_read = true
		$interact_sprite.visible = true
		target_body = body


func _on_interact_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and can_read:
		can_read = false
		$interact_sprite.visible = false
		Game.kill_text()
