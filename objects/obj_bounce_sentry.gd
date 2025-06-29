extends CharacterBody2D

@export var direction := Vector2.ZERO

@export var speed : float = 1.5

@onready var bounce_anim = preload("res://objects/bounce_anim.tscn")


func _ready() -> void:
	direction = direction.normalized()
	$AnimationPlayer.play("rotate")


func _physics_process(delta: float) -> void:
	var collision = move_and_collide(direction * speed * (delta * 60))
	if collision:
		#Make bounce animation
		var new_anim = bounce_anim.instantiate()
		new_anim.set_angle(collision.get_normal())
		new_anim.position = collision.get_position()
		add_sibling(new_anim)
		
		#Bounce off of wall
		direction = direction.bounce(collision.get_normal()).normalized()
		
		#Play sound
		Audio.play_sound("res://sounds/bounce.wav", "bounce", -3.0, false, randf_range(0.7, 1.1))
