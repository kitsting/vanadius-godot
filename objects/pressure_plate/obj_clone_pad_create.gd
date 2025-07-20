extends Node2D

var created_clone : Node = null


func create_clone(anim : String = "", flip : bool = false) -> void:
	print("creating clone...")
	if created_clone == null:
		call_deferred("add_clone_to_scene", anim, flip)
	else:
		if position.distance_to(created_clone.position) > 20:
			created_clone.queue_free()
			call_deferred("add_clone_to_scene", anim, flip)
			
		
func add_clone_to_scene(anim : String = "", flip : bool = false) -> void:
	created_clone = load("res://objects/objClone.tscn").instantiate()
	created_clone.position = position
	if anim != "":
		created_clone.play_anim(anim, flip)
	add_sibling(created_clone)
