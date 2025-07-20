extends CharacterBody2D

func _physics_process(_delta: float) -> void:
	move_and_slide()
	velocity = Vector2.ZERO


func _on_pressure_plate_area_area_entered(area: Area2D) -> void:
	if extstd.match_group(area, ["objLaser", "objLaserGreen", "objLaserBlue", "objGenericSpike"]):
		var new_explosion : Node = load("res://objects/objExplosion.tscn").instantiate()
		new_explosion.position = position
		new_explosion.set_color(Color.ORANGE, Color.ORANGE_RED)
		get_parent().call_deferred("add_child", new_explosion)
		queue_free()
