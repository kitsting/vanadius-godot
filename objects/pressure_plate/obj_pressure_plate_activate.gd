@tool
extends Node2D

var pressed = 0


@export_enum("Lasers Off", "Lasers On", "Toggle", "Weighted", "Safe") var behavior = 0:
	set(value):
		val_to_sprite(value)
		behavior = value


func _ready() -> void:
	val_to_sprite(behavior)

func val_to_sprite(value : int):
	if value == 0:
		$sprite.animation = "lasers_off"
	elif value == 1:
		$sprite.animation = "lasers_on"
	elif value == 2:
		$sprite.animation = "lasers_toggle"
	elif value == 3:
		$sprite.animation = "weighted"
	elif value == 4:
		$sprite.animation = "safe"

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") or area.is_in_group("objClone") or area.is_in_group("objPackage"):
		if pressed == 0:
			$sfx.pitch_scale = 0.9
			$sfx.play()
			$sprite.frame = 1
			
			if behavior == 0 or behavior == 3:
				Game.lasers = false
			elif behavior == 1:
				Game.lasers = true
			elif behavior == 2:
				Game.lasers = !Game.lasers
			elif behavior == 4:
				Game.safepressureplatepressed = true
				Game.alert = false
				Game.beingchased = false
		
		pressed += 1
		

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("player") or area.is_in_group("objClone") or area.is_in_group("objPackage"):
		pressed -= 1
		if pressed == 0:
			$sprite.frame = 0
			$sfx.pitch_scale = 1.0
			$sfx.play()
			
			if behavior == 3:
				#Make sure there isnt another weighted plate being pressed before setting lasers
				var plates = get_tree().get_nodes_in_group("pressure_plate")
				for plate in plates:
					if plate.get_pressed() > 0:
						return
				Game.lasers = true
			elif behavior == 4:
				Game.safepressureplatepressed = false
				
				
func get_pressed():
	return pressed
