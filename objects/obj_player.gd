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

var direction := Vector2.ZERO

var transitioning = false

@onready var indicator_off = preload("res://sprites/sprSentryIndicatorOff.png")
@onready var indicator_on = preload("res://sprites/sprSentryIndicatorOn.png")
@onready var indicator_null = preload("res://sprites/sprSentryIndicatorNull.png")
@onready var indicator_unsure = preload("res://sprites/sprSentryIndicatorUnsure.png")


func _ready() -> void:
	$sentry_indicator.visible = true

	Game.save_game()
	
	Game.connect("device_changed", update_device)
	update_device(Game.current_device)
	
	
	
func _process(delta: float) -> void:
	
	$debug/rm/value.text = Game.current_room
	$debug/HBoxContainer/value.text = str(position)
	
	
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
			position = round(position)
			get_tree().call_group("camera", "round_position") #Prevent weird offsets
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
	call_clone(velocity)
	move_and_slide()
	velocity = Vector2.ZERO
	
	

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if deathtimer >= 5 and !transitioning:
			transitioning = true
			Game.transition_room("")
			
	if Game.usedevtools:
		if Input.is_action_just_pressed("debug_unlock_camera"):
			set_collision_layer_value(1, false)
			set_collision_mask_value(1, false)


func _on_hitbox_area_entered(area: Area2D) -> void:
	if pstate == PLAYERSTATE.ALIVE:
		if area.is_in_group("objPit"):
			pstate = PLAYERSTATE.FALLING
		
		if area.is_in_group("damage"):
			pstate = PLAYERSTATE.DEAD
			
			if area.is_in_group("objLaser"):
				deathmsg = extstd.choose(["Lasers are no joke","Red means stop",Game.genericDeathMessage()])
				
			elif area.is_in_group("objLaserGreen"):
				deathmsg = extstd.choose(["Lasers are no joke", "Being green doesn't make them less deadly","Green means stop",Game.genericDeathMessage()])
				
			elif area.is_in_group("objSentry"):
				deathmsg = extstd.choose(["Giant spheres can hurt too","Get out of the way!",Game.genericDeathMessage()])
				
			elif area.is_in_group("objSentryMini"):
				deathmsg = extstd.choose(["Small but fast",Game.genericDeathMessage()])
				
			elif area.is_in_group("objSentryBounce"):
				deathmsg = extstd.choose(["Patience is important",Game.genericDeathMessage()])
				
			elif area.is_in_group("objExplosion"):
				deathmsg = extstd.choose(["Boom","The explosion was too powerful...",Game.genericDeathMessage()])
				
			elif area.is_in_group("objGenericSpike"):
				deathmsg = extstd.choose(["Pointy!","It is advised not to touch sharp objects",Game.genericDeathMessage()])
				
			elif area.is_in_group("objLaserBlue"):
				deathmsg = "Timing is key"
				
			elif area.is_in_group("surviveSpike"):
				deathmsg = extstd.choose(["Just wait it out...","It will be gone eventually...",Game.genericDeathMessage()])
				
			elif area.is_in_group("objThing") or area.is_in_group("objLabSentry"):
				deathmsg = extstd.choose(["Death by sphere","It knows","Darkness may severely limit visibility","Take caution when entering dark areas","Target acquired"])
				
			else:
				deathmsg = Game.genericDeathMessage()
				
			die()

func die():
	Game.kill_text()
	Game.beingchased = false
	$sprite.speed_scale = 1
	
	get_tree().call_group("room", "set_pausable", false)
	
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
	Game.progress["deaths"] += 1


func swap_anim(anim_name : String, flip_x := false, play_backwards := false) -> void:
	$sprite.flip_h = flip_x
	if !play_backwards:
		$sprite.play(anim_name)
	else:
		$sprite.play_backwards(anim_name)


func set_pos_facing(pos_x : int, pos_y : int, pos_facing : int):
	if pos_x != 0 and pos_y != 0:
		position = Vector2(pos_x, pos_y)
	dir = pos_facing
	
	if pos_facing == PLAYERDIR.LEFT:
		$sprite.flip_h = true
		
		
func set_state(state : PLAYERSTATE):
	pstate = state
		
		
func set_flashlight(darkness : float, light : float):
	if darkness > 0:
		$flashlight.enabled = true
		$flashlight.energy = darkness*light
		

func update_device(device):
	if Game.options["buttons"] == int(0):
		if device == InputHelper.DEVICE_GENERIC or device == InputHelper.DEVICE_XBOX_CONTROLLER or device == InputHelper.DEVICE_PLAYSTATION_CONTROLLER or device == InputHelper.DEVICE_SWITCH_CONTROLLER or device == InputHelper.DEVICE_STEAMDECK_CONTROLLER:
			%LabelKeyboard.visible = false
			%LabelGamepad.visible = true
		else:
			%LabelGamepad.visible = false
			%LabelKeyboard.visible = true
	elif Game.options["buttons"] == int(1):
		%LabelGamepad.visible = false
		%LabelKeyboard.visible = true
	elif Game.options["buttons"] == int(2):
		%LabelKeyboard.visible = false
		%LabelGamepad.visible = true


func call_clone(clone_velocity : Vector2) -> void:
	get_tree().call_group("objClone", "move", clone_velocity)


func _on_sprite_animation_changed() -> void:
	get_tree().call_group("objClone", "play_anim", $sprite.animation, $sprite.flip_h)

func get_anim() -> String:
	return $sprite.animation
	
func is_anim_flipped() -> bool:
	return $sprite.flip_h


func set_camera_link(link : bool):
	$RemoteTransform2D.update_position = link
