@tool
extends StaticBody2D

var can_read : bool = false
var target_body : Node = null

@export var file : String = "signpost"
@export var node : String = "rmNameHere"

@export_enum(
	"Wall", 
	"Grounded", 
	"Grounded (Back)", 
	"Terminal", 
	"Terminal (Grounded)", 
	"Terminal (Back)", 
	"Control") var orientation = 1:
		set(value):
			match value:
				0:
					$sprite.texture = load("res://sprites/sign/sprSignWall.png")
					$shape.disabled = true
				1:
					$sprite.texture = load("res://sprites/sign/sprSignGround.png")
					$shape.disabled = false
				2:
					$sprite.texture = load("res://sprites/sign/sprSignGroundBack.png")
					$shape.disabled = false
				3:
					$sprite.texture = load("res://sprites/sign/sprTerminalWall.png")
					$shape.disabled = true
				4:
					$sprite.texture = load("res://sprites/sign/sprTerminalGround.png")
					$shape.disabled = false
				5:
					$sprite.texture = load("res://sprites/sign/sprTerminalGroundBack.png")
					$shape.disabled = false
				6:
					$sprite.texture = load("res://sprites/sign/sprControlWall.png")
					$shape.disabled = true
			orientation = value


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$interact_sprite.play("view")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _input(event: InputEvent) -> void:
	if can_read and Input.is_action_just_pressed("ui_accept"):
		if target_body.pstate == target_body.PLAYERSTATE.ALIVE:
			Game.show_textbox(file, node)


func _on_interact_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_read = true
		$interact_sprite.visible = true
		target_body = body


func _on_interact_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and can_read:
		can_read = false
		$interact_sprite.visible = false
		Game.kill_text()
