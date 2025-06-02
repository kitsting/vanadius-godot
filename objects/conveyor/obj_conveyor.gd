@tool
extends Area2D

@export var fast = false:
	set(value):
		fast = value
		update_anim()

@export_enum("Up","Down","Left","Right") var direction = "Up":
	set(value):
		direction = value
		update_anim()

const BASE_SPD = 0.6 * 60
const FAST_SPD = 1.4 * 60

var spd = BASE_SPD
var target_body : Node = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if fast:
		spd = FAST_SPD
	else:
		spd = BASE_SPD
		
	update_anim()
	$AnimationPlayer.play("modulate_overlay")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if target_body != null:
		match direction:
			"Up":
				target_body.velocity.y = -(spd * delta * 60)
			"Down":
				target_body.velocity.y = (spd * delta * 60)
			"Left":
				target_body.velocity.x = -(spd * delta * 60)
			"Right":
				target_body.velocity.x = (spd * delta * 60)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("conveyable"):
		target_body = body


func _on_body_exited(body: Node2D) -> void:
	if body == target_body:
		target_body = null
		
		
func update_anim() -> void:
	if Engine.is_editor_hint():
		$sprite.animation = "editor_" + get_anim()
	else:
		$sprite.play(get_anim())
		
		match direction:
			"Up":
				$overlay.rotation = deg_to_rad(-90)
			"Down":
				$overlay.rotation = deg_to_rad(90)
			"Left":
				$overlay.rotation = deg_to_rad(180)
			"Right":
				$overlay.rotation = deg_to_rad(0)
				
		if fast:
			$overlay.texture = load("res://sprites/conveyor/warning_fast.png")


func reverse_direction() -> void:
	match direction:
		"Up":
			direction = "Down"
		"Down":
			direction = "Up"
		"Left":
			direction = "Right"
		"Right":
			direction = "Left"
			
	update_anim()


func get_anim() -> String:
	if fast:
		match direction:
			"Up":
				return "up_fast"
			"Down":
				return "down_fast"
			"Left":
				return "left_fast"
			"Right":
				return "right_fast"
	else:
		match direction:
			"Up":
				return "up"
			"Down":
				return "down"
			"Left":
				return "left"
			"Right":
				return "right"
	
	#fallback
	return "up"
