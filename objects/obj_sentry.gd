extends PathFollow2D

enum SENTRYSTATE
{
	HOSTILE,
	PATROLLING
}

var sstate = SENTRYSTATE.PATROLLING

var color = Game.m_sentrycolor_neutral:
	set(value):
		#redraw the circle if the color changes
		#this cuts down on potentially expensive draw calls
		if color != value:
			color = value
			queue_redraw()
		
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
	#trigger all sentries if the alert is on
	if Game.alert:
		Game.beingchased = true
		sstate = SENTRYSTATE.HOSTILE
		color = Game.m_sentrycolor_active
	else:
		color = Game.m_sentrycolor_neutral


func _physics_process(delta: float) -> void:
	if sstate == SENTRYSTATE.PATROLLING:
		#follow the path if one exists, otherwise stay stationary
		if get_parent().is_class("Path2D"):
			progress += pathspd * delta * 60
			
	if sstate == SENTRYSTATE.HOSTILE:
		canchase = false
		$sprite.play("active")
		
		#chase the player
		if target != null:
			var direction = position.direction_to(target.position) * (spd * delta * 60)
			position += direction
			
			#run away from the player if they die
			if !Game.alert or target.pstate == target.PLAYERSTATE.DEAD:
				direction = position.direction_to(target.position) * (-2 * spd * delta * 60)
				position += direction
				
				death_timer -= 1
				if death_timer == 0:
					queue_free()
	
		#speed up over time
		speedup -= 1;
		if speedup <= 0:
			spd += 0.1
			speedup = Game.m_sentryspeed_time


#start chasing if the player is nearby
func _on_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and canchase:
		if body.pstate == body.PLAYERSTATE.ALIVE and target == null:
			target = body
			Game.alert = true
			Game.beingchased = true
			$alert.play()

#function from https://forum.godotengine.org/t/smooth-circle-with-draw-circle/26033/3
func draw_circle_custom(draw_radius, draw_color : Color, max_error = 0.25):
	if radius <= 0.0:
		return

	var maxpoints = 24
	var numpoints = ceil(PI / acos(1 - max_error / draw_radius))
	numpoints = clamp(numpoints, 3, maxpoints)

	var points = PackedVector2Array([])
	for i in numpoints:
		var phi = i * PI * 2.0 / numpoints
		var v = Vector2(sin(phi), cos(phi))
		points.push_back(v * draw_radius)

	draw_colored_polygon(points, draw_color)


#draw the light around the sentry
func _draw():
	draw_circle_custom(radius+(radius*0.1), Color(color.r, color.b, color.g, 0.1))
	draw_circle_custom(radius, Color(color.r, color.b, color.g, 0.25))
