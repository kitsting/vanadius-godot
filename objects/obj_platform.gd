extends StaticBody2D

@export var target_body : Node = null

@export var min_y := 0
signal tippy_top

const SPEED = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionPolygon2D.disabled = true
	position = round(position)


func _physics_process(delta: float) -> void:
	if target_body != null:
		if target_body.pstate == Game.PLAYERSTATE.CUTSCENE:
			target_body.swap_anim("inactive")
		if !$going.playing:
			$going.play()
		target_body.set_collision_layer_value(1, false)
		target_body.set_collision_mask_value(1, false)
		target_body.z_index = z_index + 1
		$CollisionPolygon2D.disabled = false
		position.y -= round(SPEED * delta * 60)
		target_body.position.y -= round(SPEED * delta * 60)
		$Sprite2D.global_position = round(position)
		
		if min_y != 0 and position.y < min_y:
			$going.stop()
			$stop.play()
			target_body.set_collision_layer_value(1, true)
			target_body.set_collision_mask_value(1, true)
			target_body.z_index = 0
			target_body = null
			position.y = min_y
			$Sprite2D.global_position = round(position)
			$CollisionPolygon2D.disabled = true
			get_tree().call_group("camera", "shake", 1, 15, 2)
			emit_signal("tippy_top")


func lift() -> void:
	$CollisionPolygon2D.disabled = false
	$AnimationPlayer.play("shake")
	await $AnimationPlayer.animation_finished
	target_body = get_tree().get_first_node_in_group("player")
