@tool
extends StaticBody2D

@export var flip := false:
	set(value):
		flip = value
		
		if value:
			$Sprite2D.flip_h = true
			$CollisionShape2D.scale.x = -1
		else:
			$Sprite2D.flip_h = false
			$CollisionShape2D.scale.x = 1
