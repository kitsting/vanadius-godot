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
var key_pressed : int = 0

var spd : float = 40
var walkspd : float = 1
var deathtimer : int = 0
var falltimer : int = 0
var deathmsg : String = ""
var deathsound : bool = true

var pstate : PLAYERSTATE = PLAYERSTATE.ALIVE
var dir : PLAYERDIR = PLAYERDIR.DOWN


func _ready() -> void:
	
	#save
	
	pass
	
	
	
func _process(delta: float) -> void:
	if pstate == PLAYERSTATE.ALIVE:
		indicatoralpha = min(0.8,indicatoralpha+0.05)
	
	if pstate == PLAYERSTATE.NOCLIP:
		$sprite.animation = "noclip"
	
	if pstate == PLAYERSTATE.CUTSCENE:
		indicatoralpha = max(0,indicatoralpha-0.05)
		
	if pstate == PLAYERSTATE.FALLING:
		indicatoralpha = max(0,indicatoralpha-0.05)
		position.y += 2
		$sprite.frame = 1
		$sprite.speed_scale = 0
		
	if pstate == PLAYERSTATE.DEAD:
		
		#create death screen
		
		Game.beingchased = false
		$sprite.speed_scale = 1
		if dir == PLAYERDIR.DOWN:
			$sprite.play("dead")
		elif dir == PLAYERDIR.UP:
			$sprite.play("dead_up")
		else:
			$sprite.play("dead_right")
			
		if deathsound:
			$death_sound.play()
			deathsound = !deathsound
			
		#deathmsg
		
		indicatoralpha = max(0,indicatoralpha-0.05)
		
		deathtimer += 1
		
		if deathtimer == 1:
			Game.deaths += 1
			
		if deathtimer >= 5:
			#keypress
			pass
			
		if deathtimer >= 120:
			deathtimer = 120
			respawnoptions = true
	
	
	
	
	
	
	
func _physics_process(delta: float) -> void:
	var direction : Vector2 = Vector2.ZERO
	idle = true
	
	if pstate == PLAYERSTATE.ALIVE:
		#Get key presses and set direction
		if Input.is_action_pressed("ui_up"):
			$sprite.speed_scale = walkspd
			direction.y = -spd
			key_pressed += 1
			dir = PLAYERDIR.UP
			idle = false
			
		if Input.is_action_pressed("ui_down"):
			$sprite.speed_scale = walkspd
			direction.y = spd
			key_pressed += 1
			dir = PLAYERDIR.DOWN
			idle = false
			
		if Input.is_action_pressed("ui_left"):
			$sprite.speed_scale = walkspd
			direction.x = -spd
			key_pressed += 1
			dir = PLAYERDIR.LEFT
			$sprite.flip_h = true
			idle = false
			
		if Input.is_action_pressed("ui_right"):
			$sprite.speed_scale = walkspd
			direction.x = spd
			key_pressed += 1
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
		if (Input.is_action_pressed("ui_right") && Input.is_action_just_pressed("ui_left")) || (Input.is_action_pressed("ui_up") && Input.is_action_just_pressed("ui_down")):
			direction.x = 0
			direction.y = 0
			$sprite.speed_scale = 0
			$sprite.frame = 0
	
	#Move
	direction = direction.normalized()
	velocity = direction * (spd * delta * 60)
	move_and_slide()
	
	if key_pressed > 0 && key_pressed < 3:
		$sprite.frame = 1
	
	if idle:
		$sprite.speed_scale = 1
		key_pressed = 0
		if dir == PLAYERDIR.DOWN:
			$sprite.play("idle_down")
		elif dir == PLAYERDIR.UP:
			$sprite.play("idle_up")
		else:
			$sprite.play("idle_right")
	

func _input(event: InputEvent) -> void:
	pass
