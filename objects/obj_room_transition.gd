@tool
extends Area2D

@export_file("*.tscn") var target_room : String

@export var target_x : int = 0
@export var target_y : int = 0

@export_enum("Up", "Down", "Left", "Right") var direction : int = 0:
	set(value):
		direction = value
		match direction:
			0:
				rotation_degrees = 0
			1:
				rotation_degrees = 180
			2:
				rotation_degrees = 270
			3:
				rotation_degrees = 90
				
@export_group("Sizing")
@export var auto_size := true
@export var wallsize : float = 2


@export_group("Additional Settings")
@export var play_animation := true

@export var use_target_facing := false
@export var target_facing := Game.PLAYERDIR.DOWN

@export var target_state := Game.PLAYERSTATE.ALIVE
@export var preserve_state := false

var target_body : Node = null

var triggered := false


#Update size on the first frame of physics, then disable
func _physics_process(_delta: float) -> void:
	if !Engine.is_editor_hint():
		if scale.x == 1:
			update_size()
		else:
			$left_ray.enabled = false
			$right_ray.enabled = false
			set_physics_process(false)


func update_size() -> void:
	$left_ray.force_raycast_update()
	$right_ray.force_raycast_update()
	
	if $left_ray.is_colliding() and $right_ray.is_colliding() and auto_size:
		if direction == 0: #Up
			var size : float = $right_ray.get_collision_point().x - $left_ray.get_collision_point().x
			position.x = $left_ray.get_collision_point().x + (size/2)
			scale.x = size / 32.0
		elif direction == 1: #Down
			var size : float = $left_ray.get_collision_point().x - $right_ray.get_collision_point().x
			position.x = $right_ray.get_collision_point().x + (size/2)
			scale.x = size / 32.0
		elif direction == 2: #Left
			var size : float = $left_ray.get_collision_point().y - $right_ray.get_collision_point().y
			position.y = $right_ray.get_collision_point().y + (size/2) - ((wallsize-1) * 24)
			scale.x = ((size + (wallsize*24)) / 32.0)
		else: #Right
			var size : float = $right_ray.get_collision_point().y - $left_ray.get_collision_point().y
			position.y = $left_ray.get_collision_point().y + (size/2) - ((wallsize-1) * 24)
			scale.x = ((size + (wallsize*24)) / 32.0)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !triggered:
		triggered = true
		target_body = body
		
		Game.roomtargetx = target_x
		Game.roomtargety = target_y
		Game.alert = false
		Game.beingchased = false
		
		if !preserve_state:
			Game.roomtargetstate = target_state
		else:
			Game.roomtargetstate = body.pstate
			
		Game.progress_set("last_room", target_room)
		
		match direction:
			0: #Up
				Game.roomtargetfacing = Game.PLAYERDIR.DOWN
				if play_animation: body.dir = Game.PLAYERDIR.DOWN
			1: #Down
				Game.roomtargetfacing = Game.PLAYERDIR.UP
				if play_animation: body.dir = Game.PLAYERDIR.UP
			2: #Left
				Game.roomtargetfacing = Game.PLAYERDIR.RIGHT
				if play_animation: body.dir = Game.PLAYERDIR.RIGHT
			3: #Right
				Game.roomtargetfacing = Game.PLAYERDIR.LEFT
				if play_animation: body.dir = Game.PLAYERDIR.LEFT
				
		if play_animation: body.pstate = body.PLAYERSTATE.CUTSCENE
		
		if use_target_facing:
			Game.roomtargetfacing = target_facing
		
		if play_animation:
			match body.dir:
				body.PLAYERDIR.RIGHT:
					body.direction.x = body.spd
					body.swap_anim("walk_right")
				body.PLAYERDIR.LEFT:
					body.direction.x = -body.spd
					body.swap_anim("walk_right", true)
				body.PLAYERDIR.UP:
					body.direction.y -= body.spd
					body.swap_anim("walk_up")
				body.PLAYERDIR.DOWN:
					body.direction.y += body.spd
					body.swap_anim("walk_down")
				
		Game.transition_room(target_room)
