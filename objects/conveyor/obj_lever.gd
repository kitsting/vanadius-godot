extends StaticBody2D

var flipped = false

var can_flip = false

func _ready() -> void:
	$interact_sprite.play("use")

func _input(event: InputEvent) -> void:
	if can_flip and Input.is_action_just_pressed("ui_accept") and !$sprite.is_playing():
		flip()


func flip():
	get_tree().call_group("conveyor","reverse_direction")
	
	if !flipped:
		$sprite.play("flip")
		$sound.pitch_scale = 0.9
		$sound.play()
	else:
		$sprite.play_backwards("flip")
		$sound.pitch_scale = 1.1
		$sound.play()
		
	flipped = !flipped


func _on_interact_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_flip = true
		$interact_sprite.visible = true


func _on_interact_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and can_flip:
		can_flip = false
		$interact_sprite.visible = false
