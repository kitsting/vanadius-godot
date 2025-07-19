extends PathFollow2D

enum MINISENTRYSTATE
{
	HOSTILE,
	PATROLLING,
	RUNNING
}

var sstate := MINISENTRYSTATE.PATROLLING

var color := Game.m_sentrycolor_neutral:
	set(value):
		#redraw the circle if the color changes
		#this cuts down on potentially expensive draw calls
		if color != value:
			color = value
			queue_redraw()
		
var canchase := true

var playerstate : int = 0
var target : Node = null

@export var spd : float = 1.02
@export var pathspd : float = 0.8
@export var radius : int = 45:
	set(value):
		radius = value
		$radius/CollisionShape2D.shape.radius = value


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$sprite.play("patrol")
	
	$radius/CollisionShape2D.shape.radius = radius


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if sstate == MINISENTRYSTATE.PATROLLING or sstate == MINISENTRYSTATE.RUNNING:
		color = Game.m_sentrycolor_neutral
	elif sstate == MINISENTRYSTATE.HOSTILE:
		color = Game.m_sentrycolor_active
		
	if (Game.safepressureplatepressed or !Game.beingchased) and sstate == MINISENTRYSTATE.HOSTILE:
		sstate = MINISENTRYSTATE.RUNNING


func _physics_process(delta: float) -> void:
	if sstate == MINISENTRYSTATE.PATROLLING:
		#follow the path if one exists, otherwise stay stationary
		if get_parent().is_class("Path2D"):
			progress += pathspd * delta * 60
			
	if sstate == MINISENTRYSTATE.HOSTILE:
		canchase = false
		$sprite.play("active")
		
		#chase the player
		if target != null:
			var direction := global_position.direction_to(target.global_position) * (spd * delta * 60)
			global_position += direction
			
	if target != null:
		if sstate == MINISENTRYSTATE.RUNNING or target.pstate == target.PLAYERSTATE.DEAD:
			var direction := global_position.direction_to(target.global_position) * (-2 * spd * delta * 60)
			global_position += direction
			
			if $death_timer.is_stopped():
				$death_timer.start()


#function from https://forum.godotengine.org/t/smooth-circle-with-draw-circle/26033/3
func draw_circle_custom(draw_radius : float, draw_color : Color, max_error := 0.25) -> void:
	if draw_radius <= 0.0:
		return

	var maxpoints := 24
	var numpoints : int = ceil(PI / acos(1 - max_error / draw_radius))
	numpoints = clamp(numpoints, 3, maxpoints)

	var points := PackedVector2Array([])
	for i : int in numpoints:
		var phi : float = i * PI * 2.0 / numpoints
		var v := Vector2(sin(phi), cos(phi))
		points.push_back(v * draw_radius)

	draw_colored_polygon(points, draw_color)
	draw_colored_polygon(points, draw_color)


#draw the light around the sentry
func _draw() -> void:
	draw_circle_custom(radius+(radius*0.1), Color(color.r, color.b, color.g, 0.1))
	draw_circle_custom(radius, Color(color.r, color.b, color.g, 0.25))


func _on_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and canchase and Game.safepressureplatepressed == false:
		if body.pstate == body.PLAYERSTATE.ALIVE and target == null:
			target = body
			sstate = MINISENTRYSTATE.HOSTILE
			Game.beingchased = true
			$alert.play()


func _on_death_timer_timeout() -> void:
	queue_free()
