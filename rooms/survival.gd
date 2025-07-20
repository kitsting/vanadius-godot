extends Area2D

var started := false

@export var flask_node : Node = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if !started and body.is_in_group("player") and !(Game.currentroom in Game.progress.completed_rooms):
		started = true
		get_tree().call_group("surviveSpike", "extend", 18)
		get_tree().call_group("camera", "new_position", Vector2(0, -60), 0.5, true)
		get_tree().call_group("player", "set_camera_link", false)
		
		await get_tree().create_timer(1).timeout
		
		get_tree().call_group("surviveTimer", "start", 15)
		
		await get_tree().create_timer(1.5).timeout
		
		flask_node.process_mode = Node.PROCESS_MODE_INHERIT
		
		await get_tree().create_timer(15).timeout
		
		get_tree().call_group("camera", "reset_pos", 0.25)
		get_tree().call_group("player", "set_camera_link", true)
