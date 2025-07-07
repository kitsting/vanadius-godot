extends Node

var music_enabled = true
var music_target_db = -6

var blocked_channels : Array[String] = []


# Play a sound on a "channel"
# If the channel does not exist, create it
# sound: a filepath to the sound
# channel: the name of a channel to play
# volume: db for the sound. 0 is baseline
# allow_overwrite: allow resetting the sound if the same channel is requested. locks the channel if false
func play_sound(sound : String, channel : String, volume : float = 0.0, allow_overwrite : bool = false, pitch: float = 1.0) -> void:
	if !has_node(channel):
		var new_channel = AudioStreamPlayer.new()
		new_channel.name = channel
		new_channel.bus = "sfx"
		add_child(new_channel)
		
	if ((!get_node(channel).playing) or allow_overwrite) and !(channel in blocked_channels):
		get_node(channel).stream = load(sound)
		get_node(channel).pitch_scale = pitch
		get_node(channel).volume_db = volume
		get_node(channel).play()

# start a song on a specified track
func set_music(file : String, track : int = 1, fade_time : float = 0.25) -> void:
	print("Set music to "+file)
	if file != "" and music_enabled:
		if !has_node("Music/Track"+str(track)):
			var new_channel = AudioStreamPlayer.new()
			new_channel.name = "Music/Track"+str(track)
			new_channel.bus = "music"
			add_child(new_channel)
			
		var channel = get_node("Music/Track"+str(track))
		
		var loaded_stream = load(file)
		if loaded_stream != channel.stream or !channel.playing:
			var out_tween = create_tween()
			out_tween.tween_property(channel, "volume_db", -80, fade_time)
			await out_tween.finished
			
			channel.stop()
			channel.stream = loaded_stream
			channel.play()
			print("Actually playing " + file)
			
			var in_tween = create_tween()
			in_tween.tween_property(channel, "volume_db", music_target_db, fade_time)


# pause the song on a specified track
func pause_music(track : int = 1, fade_time : float = 0.4) -> void:
	var channel = get_node("Music/Track"+str(track))
	
	if !channel.stream_paused:
		var tween = create_tween()
		tween.tween_property(channel,"volume_db",-80,fade_time)
		await tween.finished
		channel.stream_paused = true


# resume a paused track
func resume_music(track : int = 1, fade_time : float = 0.4) -> void:
	var channel = get_node("Music/Track"+str(track))
	
	if channel.stream_paused:
		channel.stream_paused = false
		var tween = create_tween()
		tween.tween_property(channel,"volume_db",music_target_db,fade_time)


# stop a track
func stop_music(track : int = 1, fade_time : float = 1, purge = false) -> void:
	var channel = get_node("Music/Track"+str(track))
	
	if channel.playing:
		var tween = create_tween()
		tween.tween_property(channel,"volume_db",-80,fade_time)
		await tween.finished
		channel.stop()
		
		if purge:
			channel.queue_free()

func block_channel(channel : String, time : float):
	blocked_channels.append(channel)
	await get_tree().create_timer(time).timeout
	blocked_channels.erase(channel)
