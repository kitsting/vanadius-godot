@tool
extends Node2D

@export var vertical = false:
	set(value):
		vertical = value
		if vertical:
			rotation_degrees = 90
		else:
			rotation_degrees = 0

var on = true

@export var timer : float = 2.0
@export var offset : float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !Engine.is_editor_hint():
		$stopperL.visible = true
		$stopperR.visible = true
		$stopperD.visible = true
		
		if vertical:
			$stopperL.queue_free()
			$stopperR.queue_free()
		else:
			$stopperD.queue_free()
			
		#Start off, but on in the editor
		$laser/collision.disabled = true
		$laser/sprite.play("off")
				
		if offset > 0:
			$offset_timer.start(offset)
			await $offset_timer.timeout
			
		$go_timer.start(timer)
	

#Update size on the first frame of physics, then disable
func _physics_process(delta: float) -> void:
	if !Engine.is_editor_hint():
		if $laser.scale.x == 1:
			update_size()
		else:
			$left_ray.enabled = false
			$right_ray.enabled = false
			set_process(false)
			
			

func update_size():
	$left_ray.force_raycast_update()
	$right_ray.force_raycast_update()

	if $left_ray.is_colliding() and $right_ray.is_colliding():
		if !vertical:
			var size = $right_ray.get_collision_point().x - $left_ray.get_collision_point().x
			$laser.scale.x = size / 10.0
			$laser.position.x = to_local($left_ray.get_collision_point()).x + (size/2)
			$stopperR.position.x = to_local($left_ray.get_collision_point()).x + 1
			$stopperL.position.x = to_local($right_ray.get_collision_point()).x - 1
		else:
			var size = $right_ray.get_collision_point().y - $left_ray.get_collision_point().y
			$laser.scale.x = (size / 10.0) + 1
			$laser.position.x = to_local($left_ray.get_collision_point()).x + (size/2) - 5
			$stopperD.position.x = to_local($left_ray.get_collision_point()).x - 10


func _on_go_timer_timeout() -> void:
	$laser/sprite.play("warning")
	await get_tree().create_timer(1.5).timeout
	if $onscreen.is_on_screen():
		Audio.play_sound("res://sounds/laser_blue.ogg", "blue_laser", 0, true)
	$laser/collision.disabled = false
	$laser/sprite.play("constant")
	await get_tree().create_timer(0.6).timeout
	$laser/collision.disabled = true
	$laser/sprite.play("change_off")
	$go_timer.start(timer)
