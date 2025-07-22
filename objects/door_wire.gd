@tool
extends TileMapLayer

const LABCOLOR = Color("#111bdf")
const FACTORYCOLOR = Color("#00b200")
const CLOCKCOLOR = Color("#df1111")

@export_enum("lab", "factory", "clock") var mode := "lab":
	set(value):
		mode = value
		update_color(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_color(mode)

	if !Engine.is_editor_hint():
		update_anim(mode)



func update_color(value : String) -> void:
	if value == "lab":
		self_modulate = LABCOLOR
	elif value == "factory":
		self_modulate = FACTORYCOLOR
	elif value == "clock":
		self_modulate = CLOCKCOLOR



func update_anim(value := mode) -> void:
	if value == "lab" and Game.progress["lab_complete"]:
		await get_tree().create_timer(randf_range(0.0, 0.5)).timeout
		$AnimationPlayer.play("active")
	elif value == "factory" and Game.progress["factory_complete"]:
		await get_tree().create_timer(randf_range(0.0, 0.5)).timeout
		$AnimationPlayer.play("active")
	elif value == "clock" and Game.progress["clock_complete"]:
		await get_tree().create_timer(randf_range(0.0, 0.5)).timeout
		$AnimationPlayer.play("active")
