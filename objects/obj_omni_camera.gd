@tool
extends PathFollow2D

@export var path_speed := 0.97
@export var path_backwards := false

@export var detection_length := 80:
	set(value):
		detection_length = value
		update_ray()
		queue_redraw()

@export var oscillate := false
@export var oscillate_speed := 2.0
@export var min_length := 30
@export var max_length := 120

@export var angle := 0.0:
	set(value):
		angle = value
		update_ray()
		queue_redraw()
@export var reverse := false
@export var rotate_speed := 1.2
@export var double_line := false:
	set(value):
		double_line = value
		update_ray()
		queue_redraw()


var disabled = false
var color = Game.m_sentrycolor_neutral:
	set(value):
		if color != value:
			color = value
			queue_redraw()



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_ray()
	$sprite.play()
	if !Engine.is_editor_hint():
		if Game.area == Game.m_area_final and Game.progress.power_complete == false:
			disabled = true
			$sprite.stop()
			$sprite.frame = 0
			$Area2D/CollisionShape2D.disabled = true
		else:
			if oscillate:
				start_oscillate()
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		#trigger all sentries if the alert is on
		if Game.alert:
			$sprite.stop()
			$sprite.frame = 1
			Game.beingchased = true
			color = Game.m_sentrycolor_active
		else:
			color = Game.m_sentrycolor_neutral
		
		
		
func _physics_process(delta: float) -> void:
	if !disabled and !Engine.is_editor_hint():
		#follow the path if one exists, otherwise stay stationary
		if get_parent().is_class("Path2D"):
			progress += path_speed * delta * 60
			
		if !reverse:
			angle += rotate_speed * delta
		else:
			angle -= rotate_speed * delta
				
		angle = extstd.clamp_wrap(angle, 0, TAU)

		

func update_ray():
	if has_node("Area2D/CollisionShape2D"):
		$Area2D/CollisionShape2D.shape.b = Vector2(sin(angle), cos(angle)) * detection_length
		if double_line:
			$Area2D/CollisionShape2D.shape.a = -Vector2(sin(angle), cos(angle)) * detection_length
		else:
			$Area2D/CollisionShape2D.shape.a = Vector2(0, 0)
	queue_redraw()


func _draw():
	if !disabled:
		if double_line:
			draw_line(-Vector2(sin(angle), cos(angle)) * detection_length, Vector2(sin(angle), cos(angle)) * detection_length, color)
		else:
			draw_line(Vector2.ZERO, Vector2(sin(angle), cos(angle)) * detection_length, color)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.pstate == body.PLAYERSTATE.ALIVE:
			get_tree().call_group("objSentry", "set_body", body)
			if !Game.alert:
				Audio.play_sound("res://sounds/sndSentryAlert.mp3", "sentry")
			Game.alert = true
			Game.beingchased = true
			Audio.play_sound("res://sounds/sndCameraBeep.ogg", "camera")


func start_oscillate() -> void:
	detection_length = max_length
	await create_tween().tween_property(self, "detection_length", min_length, oscillate_speed).finished
	await create_tween().tween_property(self, "detection_length", max_length, oscillate_speed).finished
	start_oscillate()
