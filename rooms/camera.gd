extends Camera2D

var _duration := 0.0
var _period_in_ms := 0.0
var _amplitude := 0.0
var _timer := 0.0
var _last_shook_timer := 0.0
var _previous_x := 0.0
var _previous_y := 0.0
var _last_offset := Vector2(0, 0)

var previous_positions : Array[Vector2] = []


func _ready() -> void:
	set_process(true)
	
func round_position() -> void:
	position = round(position)

# Shake with decreasing intensity while there's time remaining.
func _process(delta : float) -> void:
	# Only shake when there's shake time remaining.
	if _timer == 0:
		#position = round(position)
		return
	# Only shake on certain frames.
	_last_shook_timer = _last_shook_timer + delta
	# Be mathematically correct in the face of lag; usually only happens once.
	while _last_shook_timer >= _period_in_ms:
		_last_shook_timer = _last_shook_timer - _period_in_ms
		# Lerp between [amplitude] and 0.0 intensity based on remaining shake time.
		var intensity := _amplitude * (1 - ((_duration - _timer) / _duration))
		# Noise calculation logic from http://jonny.morrill.me/blog/view/14
		var new_x := randf_range(-1.0, 1.0)
		var x_component := intensity * (_previous_x + (delta * (new_x - _previous_x)))
		var new_y := randf_range(-1.0, 1.0)
		var y_component := intensity * (_previous_y + (delta * (new_y - _previous_y)))
		_previous_x = new_x
		_previous_y = new_y
		# Track how much we've moved the offset, as opposed to other effects.
		var new_offset := Vector2(x_component, y_component)
		set_offset(get_offset() - _last_offset + new_offset)
		_last_offset = new_offset
	# Reset the offset when we're done shaking.
	_timer = _timer - delta
	if _timer <= 0:
		_timer = 0
		set_offset(get_offset() - _last_offset)

# Kick off a new screenshake effect.
func shake(duration : float, frequency : float, amplitude : float) -> void:
	#frequency *= System.options["screenshake"]
	#amplitude *= System.options["screenshake"]
	# Initialize variables.
	_duration = duration
	_timer = duration
	_period_in_ms = 1.0 / frequency
	_amplitude = amplitude
	_previous_x = randf_range(-1.0, 1.0)
	_previous_y = randf_range(-1.0, 1.0)
	# Reset previous offset, if any.
	set_offset(get_offset() - _last_offset)
	_last_offset = Vector2(0, 0)
	
	
func new_position(new_pos : Vector2, time : float, relative := false) -> void:
	previous_positions.append(offset)
	
	var tween := get_tree().create_tween()
	
	if !relative:
		tween.tween_property(self, "offset", new_pos-global_position, time)
	else:
		tween.tween_property(self, "offset", offset+new_pos, time)


func reset_pos(time : float) -> void:
	if previous_positions != []:
		var tween := get_tree().create_tween()
		tween.tween_property(self, "offset", previous_positions[0], time)
		previous_positions = []


func _input(_event: InputEvent) -> void:
	if Game.usedevtools:
		if Input.is_action_just_pressed("debug_unlock_camera"):
			limit_bottom = 100000
			limit_top = -100000
			limit_left = -100000
			limit_right = 100000
