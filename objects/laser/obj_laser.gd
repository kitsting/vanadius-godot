@tool
extends Node2D

@export var inverted := false:
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

@export var vertical := false:
	set(value):
		vertical = value
		if vertical:
			rotation_degrees = 90
		else:
			rotation_degrees = 0

@export var disable_on_room_clear := false

var on := true
var disabled := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !Engine.is_editor_hint():
		if !inverted:
			if Game.lasers:
				$laser/sprite.animation = "red_constant"
			else:
				$laser/sprite.animation = "off"
		else:
			if Game.lasers:
				$laser/sprite.animation = "off"
			else:
				$laser/sprite.animation = "green_constant"
				
		update_collision(Game.lasers)
				
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
			
		if disable_on_room_clear:
			await get_tree().create_timer(0.05).timeout
			if Game.currentroom in Game.progress.completed_rooms:
				disabled = true
				$laser/sprite.visible = false
				$laser/collision.disabled = true
	

#Update size on the first frame of physics, then disable
func _physics_process(_delta: float) -> void:
	if !Engine.is_editor_hint():
		if $laser.scale.x == 1:
			update_size()
		else:
			$left_ray.enabled = false
			$right_ray.enabled = false
			set_process(false)
			
			
func laser_change(value : bool) -> void:
	if !disabled:
		if !inverted:
			if value and !on:
				$laser/sprite.play("red_on")
			elif !value and on:
				$laser/sprite.play("red_off")
		else:
			if value and on:
				$laser/sprite.play("green_off")
			elif !value and !on:
				$laser/sprite.play("green_on")
				
		update_collision(value)


func update_size() -> void:
	$left_ray.force_raycast_update()
	$right_ray.force_raycast_update()

	if $left_ray.is_colliding() and $right_ray.is_colliding():
		if !vertical:
			var size : float = $right_ray.get_collision_point().x - $left_ray.get_collision_point().x
			$laser.scale.x = size / 10.0
			$laser.position.x = to_local($left_ray.get_collision_point()).x + (size/2)
			$stopperR.position.x = to_local($left_ray.get_collision_point()).x + 1
			$stopperL.position.x = to_local($right_ray.get_collision_point()).x - 1
		else:
			var size : float = $right_ray.get_collision_point().y - $left_ray.get_collision_point().y
			$laser.scale.x = (size / 10.0) + 1
			$laser.position.x = to_local($left_ray.get_collision_point()).x + (size/2) - 5
			$stopperD.position.x = to_local($left_ray.get_collision_point()).x - 10


func update_collision(laser_value : bool) -> void:
	if !inverted:
		$laser/collision.disabled = !laser_value
		on = laser_value
	else:
		$laser/collision.disabled = laser_value
		on = !laser_value
