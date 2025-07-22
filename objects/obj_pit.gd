extends Area2D

@export_file("*.tscn") var target_room : String

@export var target_x : int = 0
@export var target_y : int = 0

@export var direction : Game.PLAYERDIR = Game.PLAYERDIR.DOWN

@export var set_room_clear := false
@export var reveal_node := ""

@export var stop_music := true

var can_use := false
var target_body : Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$interact_sprite.visible = false
	$interact_sprite.play("use")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(_event: InputEvent) -> void:
	if can_use and target_body != null:
		if Input.is_action_just_pressed("ui_accept"):
			
			#Move to new room
			Game.roomtargetx = target_x
			Game.roomtargety = target_y
			Game.roomtargetfacing = direction
			Game.alert = false
			Game.beingchased = false
			
			Game.progress_set("last_room", target_room)
			
			if stop_music:
				Audio.stop_music()
				
			if set_room_clear:
				Game.progress_append("completed_rooms", Game.currentroom)
				
			if reveal_node != "":
				Game.progress_append("visited_rooms", reveal_node)
			
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

func set_disabled(disable := false) -> void:
	if has_node("CollisionShape2D"):
		$CollisionShape2D.disabled = disable
	
	
	
	
