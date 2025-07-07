extends StaticBody2D

enum STATE {
	STATIONARY,
	LUNGE,
	LUNGE_LOCKIN,
	MOVING,
	RETRACTING
}
var state := STATE.STATIONARY

var home_pos := Vector2.ZERO

var target_dir := Vector2.ZERO
var target_body : Node = null

var max_distance := 150.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	home_pos = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Make sure the draw call happens and make sure the base is in the correct spot
	queue_redraw()
	$Base.global_position = home_pos
	
	#Update the target direction
	if target_body != null and state == STATE.LUNGE:
		target_dir = position.direction_to(target_body.position)
		
	#Beep while drawing line
	if state == STATE.LUNGE or state == STATE.LUNGE_LOCKIN:
		if !$LockIn.playing:
			$LockIn.pitch_scale += 0.01
			$LockIn.play()
		
	#Move in target direction
	if state == STATE.MOVING:
		if !$TheChain.playing:
			$TheChain.pitch_scale = 1
			$TheChain.play()
		
		var collide := move_and_collide(target_dir * 2.5 * (delta * 60))
		
		#Stop if hitting something (and explode)
		if collide:
			var new_explosion : Node = load("res://objects/objExplosion.tscn").instantiate()
			new_explosion.position = collide.get_position()
			add_sibling(new_explosion)
			state = STATE.RETRACTING
			
		#Stop if too far
		if position.distance_to(home_pos) > max_distance:
			$Stop.play()
			state = STATE.RETRACTING
			
	#Return to home position
	if state == STATE.RETRACTING:
		if !$TheChain.playing:
			$TheChain.pitch_scale = 0.5
			$TheChain.play()
		
		target_dir = position.direction_to(home_pos)
		move_and_collide(target_dir * 1.5)
		if position.distance_to(home_pos) <= 3:
			position = home_pos
			state = STATE.STATIONARY
			
			if $SearchArea.overlaps_body(target_body):
				#Go again immediately if the player is within the radius
				if target_body.pstate == target_body.PLAYERSTATE.ALIVE:
					go()
			else:
				target_body = null


func _on_search_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and state == STATE.STATIONARY:
		if body.pstate == body.PLAYERSTATE.ALIVE:
			target_body = body
			go()
		

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


func _draw() -> void:
	draw_line(Vector2.ZERO, home_pos - position, Color.BLACK)
	
	if state == STATE.STATIONARY:
		draw_circle_custom(45+(45*0.1), Color(255, 0, 0, 0.1))
		draw_circle_custom(45, Color(255, 0, 0, 0.1))
		
	if target_body != null and (state == STATE.LUNGE or state == STATE.LUNGE_LOCKIN):
		draw_line(Vector2.ZERO, target_dir * max_distance, Color.RED, 2)
		
		
func go() -> void:
	$LockIn.pitch_scale = 1
	state = STATE.LUNGE
	await get_tree().create_timer(1).timeout
	state = STATE.LUNGE_LOCKIN
	await get_tree().create_timer(0.5).timeout
	state = STATE.MOVING
