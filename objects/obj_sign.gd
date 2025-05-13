extends StaticBody2D

var can_read : bool = false
var target_body : Node = null

@export var file : String = "test"
@export var node : String = "test_text"

@export_enum(
	"Wall", 
	"Grounded", 
	"Grounded (Back)", 
	"Terminal", 
	"Terminal (Grounded)", 
	"Terminal (Back)", 
	"Control") var orientation = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _input(event: InputEvent) -> void:
	if can_read and Input.is_action_just_pressed("ui_accept"):
		if target_body.pstate == target_body.PLAYERSTATE.ALIVE:
			Game.tutorialinteract = false
			Game.show_textbox(file, node)


func _on_interact_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_read = true
		target_body = body


func _on_interact_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and can_read:
		can_read = false
		Game.kill_text()
