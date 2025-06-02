extends CharacterBody2D

func _physics_process(delta: float) -> void:
	move_and_slide()
	velocity = Vector2.ZERO


func _on_pressure_plate_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("objLaser") or area.is_in_group("objLaserGreen") or area.is_in_group("objLaserBlue") or area.is_in_group("objGenericSpike"):
		var new_explosion = load("res://objects/objExplosion.tscn").instantiate()
		new_explosion.position = position
		new_explosion.set_color(Color.ORANGE, Color.ORANGE_RED)
		get_parent().add_child(new_explosion)
		queue_free()
