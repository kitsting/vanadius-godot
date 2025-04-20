extends Node2D


@export var spikeout = false:
	set(value):
		spikeout = value
		
		if spikeout:
			Audio.play_sound("res://sounds/sndRetractingSpike.ogg", "sndRetractingSpike")
			$Area2D/CollisionShape2D.disabled = false
		else:
			$Area2D/CollisionShape2D.disabled = true


func _ready() -> void:
	$AnimationPlayer.play("cycle")
