extends PathFollow2D

enum MODE {
	SLEEPING,
	CHASE,
	FOLLOW_PATH,
	CUTSCENE
}
@export var state := MODE.CHASE:
	set(value):
		state = value
		if value != MODE.FOLLOW_PATH:
			$Area2D/path_shape.disabled = true
		else:
			$Area2D/path_shape.disabled = false

@export var path_spd := 0.7
@export var chase_spd := 0.4

var player_reference : Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_reference = get_tree().get_first_node_in_group("player")
	
	if state != MODE.FOLLOW_PATH:
		$Area2D/path_shape.disabled = true
	else:
		$Area2D/path_shape.disabled = false

	if state == MODE.SLEEPING:
		$sleep_particles.emitting = true
		$AnimatedSprite2D.play("off")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == MODE.FOLLOW_PATH and get_parent().is_class("Path2D"):
		progress += path_spd * delta * 60
		
		if $onscreen.is_on_screen():
			path_spd = 0.45
		else:
			path_spd = 1.1

	if state == MODE.CHASE and player_reference != null:
		var direction = global_position.direction_to(player_reference.global_position) * (chase_spd * delta * 60)
		global_position += direction
