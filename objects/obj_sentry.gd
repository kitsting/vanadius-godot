extends PathFollow2D

enum sentrystate
{
	hostile,
	patrolling
}

var sstate = sentrystate.patrolling
var color = Game.m_sentrycolor_neutral
var canchase = true
var speedup = Game.m_sentryspeed_time

var playerstate = 0
var target : Node = null

@export var spd = 0.97
@export var pathspd = 0.75
@export var radius = 45
@export var death_timer = 160

var end_angle = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$sprite.play("patrol")
	
	if spd > 1:
		spd = 1
	
	if position.x < 0 or position.x > Game.room_width:
		spd = 1.5
		
	$radius/CollisionShape2D.shape.radius = radius


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Game.alert == false:
		color = Game.m_sentrycolor_neutral
	else:
		color = Game.m_sentrycolor_active
		
	if Game.alert:
		Game.beingchased = true
		sstate = sentrystate.hostile
		
	queue_redraw()
		
		

func _physics_process(delta: float) -> void:
	if sstate == sentrystate.patrolling:
		if get_parent().is_class("Path2D"):
			progress += pathspd * delta * 60
			
	if sstate == sentrystate.hostile:
		canchase = false
		$sprite.play("active")
		
		if target != null:
			var direction = position.direction_to(target.position) * (spd * delta * 60)
			position += direction
			
			if !Game.alert or target.pstate == target.PLAYERSTATE.DEAD:
				direction = position.direction_to(target.position) * (-2 * spd * delta * 60)
				position += direction
				
				death_timer -= 1
				if death_timer == 0:
					queue_free()
					
	speedup -= 1;
	if speedup <= 0:
		spd += 0.1
		speedup = Game.m_sentryspeed_time


func _on_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and canchase:
		if body.pstate == body.PLAYERSTATE.ALIVE and target == null:
			target = body
			Game.alert = true
			Game.beingchased = true
			$alert.play()

func draw_circle_custom(draw_radius, draw_color : Color):
	if radius <= 0.0:
		return

	var maxpoints = 24

	var numpoints = ceil(PI / acos(1 - 0.25 / draw_radius))
	numpoints = clamp(numpoints, 3, maxpoints)

	var points = PackedVector2Array([])

	for i in numpoints:
		var phi = i * PI * 2.0 / numpoints
		var v = Vector2(sin(phi), cos(phi))
		points.push_back(v * draw_radius)

	draw_colored_polygon(points, draw_color)


func _draw():
	draw_circle_custom(radius+(radius*0.1), Color(color.r, color.b, color.g, 0.1))
	draw_circle_custom(radius, Color(color.r, color.b, color.g, 0.25))
