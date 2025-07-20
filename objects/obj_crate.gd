@tool
extends StaticBody2D

@export_enum("big", "small") var size := "big":
	set(value):
		size = value
		if value == "big":
			set_size(true)
		else:
			set_size(false)
			
@export var disable_on_room_clear := false


func _ready() -> void:
	if disable_on_room_clear:
		await get_tree().create_timer(0.05).timeout
		if Game.currentroom in Game.progress.completed_rooms:
			queue_free()


func set_size(big := true) -> void:
	$sprite_big.visible = big
	$sprite_mini.visible = !big
	$shape_big.disabled = !big
	$shape_mini.disabled = big
	
	$area/shape_big2.disabled = !big
	$area/shape_mini2.disabled = big


func explode() -> void:
	await get_tree().create_timer(0.05).timeout #chain explosion
	var explosion : Node = load("res://objects/objExplosion.tscn").instantiate()
	if size == "big":
		explosion.position = position + $sprite_big.position
	else:
		explosion.position = position + $sprite_mini.position
	explosion.set_color(Color("#c700b7"), Color("#c70054"))
	explosion.set_big_hitbox()
	add_sibling(explosion)
	
	queue_free()


func _on_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("objExplosion"):
		explode()
