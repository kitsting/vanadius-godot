extends Area2D

var pressed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Game.progress["lab_complete"]:
		$sprite.frame = 2
		$shape.disabled = true
		pressed = true
		await get_tree().create_timer(0.2).timeout
		get_tree().call_group("surviveSpike","call_deferred","spike_in")
	else:
		await get_tree().create_timer(0.2).timeout
		get_tree().call_group("surviveSpike","call_deferred","spike_out")



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !pressed:
		pressed = true
		$shape.disabled = true
		get_tree().call_group("surviveSpike","call_deferred", "spike_in")
		get_tree().call_group("camera", "shake", 0.5, 45, 2)
		$AudioStreamPlayer.play()
		Game.progress_set("lab_complete", true)
		$sprite.play()
		
