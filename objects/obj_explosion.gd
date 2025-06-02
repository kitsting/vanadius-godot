extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("default")
	await get_tree().create_timer(0.1).timeout
	if $onscreen.is_on_screen():
		Audio.play_sound("res://sounds/sndExplosion.ogg", "explosion")



func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()


func set_color(color_light : Color, color_dark: Color):
	material.set_shader_parameter("replace_0", color_light)
	material.set_shader_parameter("replace_1", color_dark)
