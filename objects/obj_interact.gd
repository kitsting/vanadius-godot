extends Area2D

var can_read : bool = false
var target_body : Node = null

@export var file : String = "environmental"
@export var node : String

@export_enum("view", "use") var interact_mode := "view"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$interact_sprite.play(interact_mode)

	
	
func _input(_event: InputEvent) -> void:
	if can_read and Input.is_action_just_pressed("ui_accept") and node != "":
		if target_body.pstate == target_body.PLAYERSTATE.ALIVE:
			Game.show_textbox(file, node)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_read = true
		$interact_sprite.visible = true
		target_body = body


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and can_read:
		can_read = false
		$interact_sprite.visible = false
		Game.kill_text()
