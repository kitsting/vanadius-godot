extends Area2D

@export_file("*.tscn") var target_room : String

@export var target_x : int = 0
@export var target_y : int = 0

@export var direction : Game.PLAYERDIR = Game.PLAYERDIR.DOWN

var can_use = false
var target_body : Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$interact_sprite.play("use")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent) -> void:
	if can_use and target_body != null:
		if Input.is_action_just_pressed("ui_accept"):
			
			#Move to new room
			Game.roomtargetx = target_x
			Game.roomtargety = target_y
			Game.roomtargetfacing = direction
			Game.alert = false
			Game.beingchased = false
			
			Game.transition_room(target_room, true)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_use = true
		$interact_sprite.visible = true
		target_body = body


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and can_use:
		can_use = false
		$interact_sprite.visible = false
		target_body = null
