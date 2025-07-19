extends Area2D

var homing := false

enum dir {
	UP = 90,
	DOWN = 270,
	LEFT = 180,
	RIGHT = 0
}

@export var direction := dir.DOWN
var move_direction := Vector2.ZERO

var can_explode := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$rotate.play("spin")
	move_direction = Vector2(cos(deg_to_rad(direction)), -sin(deg_to_rad(direction)))
	
	await get_tree().create_timer(0.05).timeout
	
	can_explode = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += 100 * delta * move_direction
	

func explode() -> void:
	if can_explode:
		var explosion : Node = load("res://objects/objExplosion.tscn").instantiate()
		explosion.position = position
		explosion.set_color(Color("#c700b7"), Color("#c70054"))
		add_sibling(explosion)
		
		if $VisibleOnScreenNotifier2D.is_on_screen():
			Audio.play_sound("res://sounds/sndGlass.ogg", "bottle", 0.0, true, randf_range(0.8, 1.2))
		
		queue_free()


func _on_body_entered(_body: Node2D) -> void:
	call_deferred("explode")

func _on_area_entered(area: Area2D) -> void:
	if extstd.match_group(area, ["objLaser", "objLaserGreen"]):
		call_deferred("explode")
