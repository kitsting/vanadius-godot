extends CanvasLayer

var started = false


func start(time : float) -> void:
	visible = true
	await get_tree().create_timer(0.3).timeout
	visible = false
	await get_tree().create_timer(0.3).timeout
	visible = true
	await get_tree().create_timer(0.3).timeout
	visible = false
	await get_tree().create_timer(0.3).timeout
	visible = true
	$Timer.start(time)
	started = true
	await $Timer.timeout
	visible = false


func _process(delta: float) -> void:
	if started:
		$Label2.text = str("%.2f" % $Timer.time_left)
