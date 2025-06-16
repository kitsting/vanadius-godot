@tool
extends Node2D

var pressed = 0

@export_enum("up", "down", "left", "right") var direction = "down":
	set(value):
		direction = value
		$sprite.animation = value
		
@export var target_reciever : Node = null


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") or area.is_in_group("objClone") or area.is_in_group("objPackage"):
		if pressed == 0:
			$sfx.pitch_scale = 1.1
			$sfx.play()
			$sprite.frame = 1
			
			if target_reciever != null:
				target_reciever.create_clone()
		
		pressed += 1
		

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("player") or area.is_in_group("objClone") or area.is_in_group("objPackage"):
		pressed -= 1
		if pressed == 0:
			$sprite.frame = 0
			$sfx.pitch_scale = 1.0
			$sfx.play()
