@tool
extends Node2D

@export var inverted = false:
	set(value):
		inverted = value
		if inverted:
			$laser/sprite.animation = "green_constant"
			$laser.add_to_group("objLaserGreen")
			$laser.remove_from_group("objLaser")
		else:
			$laser/sprite.animation = "red_constant"
			$laser.add_to_group("objLaser")
			$laser.remove_from_group("objLaserGreen")

@export var vertical = false:
	set(value):
		vertical = value
		if vertical:
			rotation_degrees = 90
		else:
			rotation_degrees = 0
			
var on = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !inverted:
		if Game.lasers:
			$laser/sprite.animation = "red_constant"
			$laser/collision.disabled = false
			on = true
		else:
			$laser/sprite.animation = "off"
			$laser/collision.disabled = true
			on = false
	else:
		if Game.lasers:
			$laser/sprite.animation = "off"
			$laser/collision.disabled = true
			on = false
		else:
			$laser/sprite.animation = "green_constant"
			$laser/collision.disabled = false
			on = true
			
	Game.connect("lasers_changed",laser_change.call_deferred)
	
	if !Engine.is_editor_hint():
		$stopperL.visible = true
		$stopperR.visible = true
		$stopperD.visible = true
		
		if vertical:
			$stopperL.queue_free()
			$stopperR.queue_free()
		else:
			$stopperD.queue_free()
	

func _physics_process(delta: float) -> void:
	if $laser.scale.x == 1:
		update_size()
		pass
	else:
		$left_ray.enabled = false
		$right_ray.enabled = false
		set_process(false)
			
			
func laser_change(value):
	if !inverted:
		if value:
			if !on:
				$laser/sprite.play("red_on")
			$laser/collision.disabled = false
			on = true
		else:
			if on:
				$laser/sprite.play("red_off")
			$laser/collision.disabled = true
			on = false
	else:
		if value:
			if on:
				$laser/sprite.play("green_off")
			$laser/collision.disabled = true
			on = false
		else:
			if !on:
				$laser/sprite.play("green_on")
			$laser/collision.disabled = false
			on = true
			

func update_size():
	$left_ray.force_raycast_update()
	$right_ray.force_raycast_update()
	if $left_ray.is_colliding():
		print("hit")
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
			$laser.position.x = to_local($left_ray.get_collision_point()).x + (size/2) - 3
			$stopperD.position.x = to_local($left_ray.get_collision_point()).x - 8
			print(size)
