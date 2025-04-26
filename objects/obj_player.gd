extends CharacterBody2D

enum PLAYERDIR {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

enum PLAYERSTATE {
	ALIVE,
	CUTSCENE,
	DEAD,
	FALLING,
	NOCLIP
}

#layer_depth("Ceiling",objPlayer.depth-225);
#global.alert = false
#screenaplha = 0

var respawnoptions : bool = false
var indicatoralpha : float = 0.8
var idle : bool = false

var spd : float = 1.4 * 60
var walkspd : float = 1
var deathtimer : int = 0
var falltimer : int = 0
var deathmsg : String = ""

var pstate : PLAYERSTATE = PLAYERSTATE.ALIVE
var dir : PLAYERDIR = PLAYERDIR.DOWN

var direction : Vector2 = Vector2.ZERO

var transitioning = false

@onready var indicator_off = preload("res://sprites/sprSentryIndicatorOff.png")
@onready var indicator_on = preload("res://sprites/sprSentryIndicatorOn.png")
@onready var indicator_null = preload("res://sprites/sprSentryIndicatorNull.png")
@onready var indicator_unsure = preload("res://sprites/sprSentryIndicatorUnsure.png")


func _ready() -> void:
	$sentry_indicator.visible = true

	Game.save_game()
	
	
	
func _process(delta: float) -> void:
	$sentry_indicator/texture.modulate.a = indicatoralpha
	
	var sentry_count = get_tree().get_node_count_in_group("objSentry")
	var minisentry_count = get_tree().get_node_count_in_group("objSentryMini")
	
	if Game.alert and sentry_count != 0:
		$sentry_indicator/warning_anim.play("warning")
	else:
		$sentry_indicator/warning_anim.stop()
		$sentry_indicator/warning.visible = false
		
	if Game.checkArea() != Game.m_area_deeplab:
		if !Game.beingchased:
			$sentry_indicator/texture.texture = indicator_off
		else:
			$sentry_indicator/texture.texture = indicator_on
			
		if sentry_count == 0 and minisentry_count == 0:
			$sentry_indicator/texture.texture = indicator_null
	else:
		$sentry_indicator/texture.texture = indicator_unsure
			
		
	
	if pstate == PLAYERSTATE.ALIVE:
		indicatoralpha = min(0.8,indicatoralpha+(0.05*delta*60))
	
	if pstate == PLAYERSTATE.NOCLIP:
		$sprite.animation = "noclip"
	
	if pstate == PLAYERSTATE.CUTSCENE:
		indicatoralpha = max(0,indicatoralpha-(0.05*delta*60))
		
	if pstate == PLAYERSTATE.FALLING:
		indicatoralpha = max(0,indicatoralpha-(0.05*delta*60))
		position.y += 2
		$sprite.frame = 1
		$sprite.speed_scale = 0
		
	if pstate == PLAYERSTATE.DEAD:
		
		indicatoralpha = max(0,indicatoralpha-(0.05*delta*60))
		
		deathtimer += 1

			
		if deathtimer >= 120:
			deathtimer = 120
			respawnoptions = true
	
	
	
func _physics_process(delta: float) -> void:
	idle = true
	
	if pstate != PLAYERSTATE.CUTSCENE and pstate != PLAYERSTATE.FALLING:
		direction = Vector2.ZERO
	
	if pstate == PLAYERSTATE.ALIVE:
		
		#Get key presses and set direction
		if Input.is_action_pressed("ui_up"):
			$sprite.speed_scale = walkspd
			direction.y = -spd
			dir = PLAYERDIR.UP
			idle = false
			
		if Input.is_action_pressed("ui_down"):
			$sprite.speed_scale = walkspd
			direction.y = spd
			dir = PLAYERDIR.DOWN
			idle = false
			
		if Input.is_action_pressed("ui_left"):
			$sprite.speed_scale = walkspd
			direction.x = -spd
			dir = PLAYERDIR.LEFT
			$sprite.flip_h = true
			idle = false
			
		if Input.is_action_pressed("ui_right"):
			$sprite.speed_scale = walkspd
			direction.x = spd
			dir = PLAYERDIR.LEFT
			$sprite.flip_h = false
			idle = false
			
		if direction.x != 0:
			$sprite.play("walk_right")
		else:
			if direction.y < 0:
				$sprite.play("walk_up")
			else:
				$sprite.play("walk_down")
			
		#Check for opposite key presses
		if (Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left")) or (Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_down")):
			direction.x = 0
			direction.y = 0
			idle = true
			
		if idle:
			$sprite.speed_scale = 1
			if dir == PLAYERDIR.DOWN:
				$sprite.play("idle_down")
			elif dir == PLAYERDIR.UP:
				$sprite.play("idle_up")
			else:
				$sprite.play("idle_right")
				

	#Move
	direction = direction.normalized()
	velocity += direction * (spd * delta * 60)
	move_and_slide()
	velocity = Vector2.ZERO
	
	

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if deathtimer >= 5 and !transitioning:
			transitioning = true
			var new_transition = load("res://objects/ToBlack.tscn").instantiate()
			new_transition.set_speed(2.5)
			get_tree().get_root().add_child(new_transition)
			await new_transition.midpoint
			get_tree().reload_current_scene()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if pstate == PLAYERSTATE.ALIVE:
		if area.is_in_group("objPit"):
			pstate = PLAYERSTATE.FALLING
		
		if area.is_in_group("damage"):
			pstate = PLAYERSTATE.DEAD
			
			if area.is_in_group("objLaser"):
				deathmsg = extstd.choose(["Lasers are no joke","Red means stop",Game.genericDeathMessage()])
				
			elif area.is_in_group("objLaserGreen"):
				deathmsg = extstd.choose(["Being green doesn't make them less deadly","In this world, anything can be deadly",Game.genericDeathMessage()])
				
			elif area.is_in_group("objSentry"):
				deathmsg = extstd.choose(["Giant spheres can hurt too","Get out of the way!",Game.genericDeathMessage()])
				
			elif area.is_in_group("objSentryMini"):
				deathmsg = extstd.choose(["Small but fast",Game.genericDeathMessage()])
				
			elif area.is_in_group("objSentryBounce"):
				deathmsg = extstd.choose(["Patience is important",Game.genericDeathMessage()])
				
			elif area.is_in_group("objExplosion"):
				deathmsg = extstd.choose(["Boom","...But the explosion was too powerful",Game.genericDeathMessage()])
				
			elif area.is_in_group("objExplosionGreen"):
				deathmsg = extstd.choose(["Like normal explosions, green explosions also hurt","It's a good thing robots can't feel pain, huh?",Game.genericDeathMessage()])
				
			elif area.is_in_group("objGenericSpike"):
				deathmsg = extstd.choose(["Pointy!","It is advised not to touch sharp objects",Game.genericDeathMessage()])
				
			elif area.is_in_group("objLaserBlue"):
				deathmsg = "Timing is key"
				
			elif area.is_in_group("objLaserPink"):
				deathmsg = extstd.choose(["Just wait it out...","It will be gone eventually...",Game.genericDeathMessage()])
				
			elif area.is_in_group("objThing") or area.is_in_group("objLabSentry"):
				deathmsg = extstd.choose(["Death by sphere","It knows","Darkness may severely limit visibility","Take caution when entering dark areas","Target acquired"])
				
			else:
				deathmsg = Game.genericDeathMessage()
				
			die()

func die():
	Game.beingchased = false
	$sprite.speed_scale = 1
	
	if dir == PLAYERDIR.DOWN:
		$sprite.play("dead")
	elif dir == PLAYERDIR.UP:
		$sprite.play("dead_up")
	else:
		$sprite.play("dead_right")
	
	$death_sound.play()
	$AnimationPlayer.play("show_death_screen")
	if deathmsg == "":
		deathmsg = Game.genericDeathMessage();
	$death_screen/ColorRect/deathmsg.text = deathmsg
	Game.deaths += 1


func swap_anim(anim_name : String, flip_x : bool = false) -> void:
	$sprite.flip_h = flip_x
	$sprite.play(anim_name)
