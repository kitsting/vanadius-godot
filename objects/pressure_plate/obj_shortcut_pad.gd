@tool
extends Node2D

@export var specific_gate : Node = null

var pressed : int = 0


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") or area.is_in_group("objClone") or area.is_in_group("objPackage"):
		if pressed == 0:
			$sfx.pitch_scale = 1.1
			$sfx.play()
			$sprite.frame = 1
			
			if specific_gate == null:
				get_tree().call_group("shortcut_gate", "lower")
			else:
				if specific_gate.has_method("lower"):
					specific_gate.lower()
				else:
					get_tree().call_group("shortcut_gate", "lower")
		
		pressed += 1
		

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("player") or area.is_in_group("objClone") or area.is_in_group("objPackage"):
		pressed -= 1
		if pressed == 0:
			$sprite.frame = 0
			$sfx.pitch_scale = 1.0
			$sfx.play()
