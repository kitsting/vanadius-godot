extends Area2D

var big_hitbox : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$shape_big.disabled = true
	$CollisionShape2D.disabled = true
	$AnimatedSprite2D.play("default")
	await get_tree().create_timer(0.1).timeout
	$CollisionShape2D.disabled = false
	if big_hitbox:
		$shape_big.disabled = false
	if $onscreen.is_on_screen():
		Audio.play_sound("res://sounds/sndExplosion.ogg", "explosion", 0.0, true, randf_range(0.8, 1.2))



func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()


func set_color(color_light : Color, color_dark: Color) -> void:
	material.set_shader_parameter("replace_0", color_light)
	material.set_shader_parameter("replace_1", color_dark)


func set_big_hitbox() -> void:
	big_hitbox = true
