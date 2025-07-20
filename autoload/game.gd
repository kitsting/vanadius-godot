extends Node

const unfocus_color = Color(0.494, 0.494, 0.494)
const focus_color = Color.WHITE

const m_area_null = ""
const m_area_ruin = "Forgotten Ruins"
const m_area_cave = "Mysterious Cave"
const m_area_ruin_sub2 = "Ruin Transport Tubes"
const m_area_lab = "The Lab"
const m_area_deeplab = "Deep Lab"
const m_area_clock = "The Clock Tower"
const m_area_clock_sub1 = "Maintainence Room"
const m_area_clock_sub2 = "Tower Core"
const m_area_factory = "The Factory"
const m_area_final = "Power Plant"
const m_area_final_sub2 = "The End"
const m_area_final_sub3 = "Testing Environments"
const m_area_outside = "The Outside"

const m_towertimermax = 360
const m_total_collectibles = 15

const m_sentrycolor_neutral = Color.WHITE
const m_sentrycolor_active = Color.RED

const m_savename = "save.sav"
const m_statsname = "stats.sav"
const m_configname = "config.json"
const m_devtoolname = "devtools.vnd"

enum PLAYERDIR {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

enum PLAYERSTATE {
	ALIVE,
	CUTSCENE,
	DEAD,
	FALLING,
	NOCLIP
}

signal lasers_changed(value : bool)

var roomtargetx : int = 0
var roomtargety : int = 0
var roomtargetfacing : int = 1
var roomtargetstate : PLAYERSTATE = PLAYERSTATE.ALIVE

var current_room := ""

var playing := false
var clock_counting := false

var playing_timer : Node = null
var clock_timer : Node = null
var clock_ui : Node = null

var safepressureplatepressed := false

var lasers := true:
	set(value):
		lasers = value
		emit_signal("lasers_changed", value)

var beingchased := false
var alert := false

#Developer tools
var showtimer := false
var noclipmode := false
var usedevtools := true

var version := "1.3.0-beta0719"

var roomtargetarea := "Nonexistent"
var area := roomtargetarea

var room_width := 320


# Default settings
var options := {
	#Audio
	"master_volume" : 1.0,
	"music_volume" : 0.8,
	"sound_volume" : 1.0,
	#Accessibility
	"screenshake" : true,
	#Graphics
	"fullscreen" : true,
	"pause_on_lost_focus" : false,
	"buttons" : 0,
}
var default_options := options.duplicate(true)

var file_loaded := false
var progress := {
	#General progression
	"lab_complete" : false,
	"deeplab_complete" : false,
	"clock_complete" : false,
	"factory_complete" : false,
	"gates_down" : false,
	"power_complete" : false,
	"bonus_revealed" : false,
	
	#Power plant progression
	"pswitch_blue" : false,
	"pswitch_green" : false,
	"pswitch_yellow" : false,
	"pswitch_red" : false,
	
	#Global stats
	"deaths" : 0,
	"time_sec" : 0,
	"collectibles" : [],
	"visited_rooms" : [],
	"gates" : [],
	"completed_rooms" : [],
	"read_entries" : [],
	
	#Set at save/load time
	"last_area" : "",
	"last_room" : "",
	"last_room_x" : 0,
	"last_room_y" : 0,
	"last_room_dir" : PLAYERDIR.DOWN,
	"last_room_state" : PLAYERSTATE.ALIVE,
	
	#Time left to complete the Clock Tower
	"towertime_left" : -4,
}
var default_progress := progress.duplicate(true)

var stats := {
	"game_completed" : false,
	"game_good_ending" : false,
	"best_time_sec" : 100000,
	"best_deaths" : 1000,
}

var current_device := InputHelper.DEVICE_KEYBOARD
signal device_changed

signal gates_lowered

var chase_cutscene_seen := false


func _ready() -> void:
	load_options()
	load_game()
	current_device = InputHelper.guess_device_name()
	InputHelper.connect("device_changed", _on_device_changed)


func update_options() -> void:
	#Fullscreen
	if options["fullscreen"]:
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			
	#Volume
	if options["sound_volume"] == 0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("sfx"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("sfx"), false)
	if options["music_volume"] == 0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("music"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("music"), false)
	if options["master_volume"] == 0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sfx"), ((options["sound_volume"]-1)*18))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), ((options["music_volume"]-1)*18))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), ((options["master_volume"]-1)*18))
		

#Save files
func save_options() -> void:
	save_file(m_configname, options)
	update_options()
	
func save_progress() -> void:
	save_file(m_savename, progress)
	file_loaded = true
	
func save_stats() -> void:
	save_file(m_statsname, stats)
	

#Load files
func load_options() -> void:
	load_file(m_configname, options)
	update_options()

func load_progress() -> void:
	if load_file(m_savename, progress, false):
		file_loaded = true
	else:
		file_loaded = false

func load_stats() -> void:
	load_file(m_statsname, stats)
		

## Load a file into a dictionary with useful output. Returns true if it is successful, false if it is not
func load_file(filename : String, destination : Dictionary, allow_floats := true) -> bool:
	print("loading " + filename)
	if FileAccess.file_exists("user://"+filename):
		var file := FileAccess.open("user://"+filename, FileAccess.READ)
		var text : Variant = JSON.parse_string(file.get_as_text())
		for option : Variant in text:
			if destination.has(option):
				var to_write : Variant = text[option]
				if !allow_floats:
					if to_write is float:
						to_write = int(to_write)
					if to_write is Array:
						var new_array : Array[Variant] = []
						for item : Variant in to_write:
							if item is float:
								new_array.append(int(item))
							else:
								new_array.append(item)
						to_write = new_array
				print_rich("[color=web_gray]" + option+" > "+str(to_write) + "[/color]")
				destination[option] = to_write
		return true
	else:
		print(filename + " doesn't exist")
		return false


func save_file(filename : String, source : Dictionary) -> void:
	var file := FileAccess.open("user://"+filename, FileAccess.WRITE)
	file.store_line(JSON.stringify(source))
	print(filename + " saved")


#Set values
func option_set(opt_name : String, value : Variant) -> void:
	options[opt_name] = value
	save_options()
	
func progress_set(opt_name : String, value : Variant) -> void:
	progress[opt_name] = value
	
func stats_set(opt_name : String, value : Variant) -> void:
	stats[opt_name] = value
	
func progress_append(opt_name : String, value : Variant) -> void:
	if progress[opt_name] is Array:
		if !value in progress[opt_name]:
			progress[opt_name].append(value)


#Convert seconds into a user-readable string
func getTimeString(seconds : int, usehours : bool = true) -> String:
	
	@warning_ignore("integer_division") #Integer division is used to truncate the leftover part
	var minutes : int = seconds/60
	
	@warning_ignore("integer_division") #Integer division is used to truncate the leftover part
	var hours : int = minutes/60
	
	var minutes_string := str(minutes%60)
	if (minutes%60) < 10:
		minutes_string = "0" + minutes_string
		
	var seconds_string := str(seconds%60)
	if (seconds%60) < 10:
		seconds_string = "0" + seconds_string
	
	if usehours:
		return str(hours) + ":" + minutes_string + ":" + seconds_string
	else:
		return str(minutes) + ":" + seconds_string


func boolToOnOff(variable : bool) -> String:
	if variable:
		return "On"
	else:
		return "Off"
		
		
func checkArea() -> String:
	if get_tree().root.is_in_group("room"):
		return get_tree().root.checkArea()
	
	return m_area_null


func transition_room(room : String, pit : bool = false) -> void:
	if room != null:
		get_tree().paused = false
		alert = false
		beingchased = false
		
		var new_transition : Node = load("res://objects/ToBlack.tscn").instantiate()
		if !pit:
			new_transition.set_speed(2.5)
		else:
			new_transition.set_speed(1.25)
			new_transition.set_wait(2)
		get_tree().get_root().add_child(new_transition)
		await new_transition.midpoint
		if room != "":
			if pit:
				get_tree().unload_current_scene()
				Audio.play_sound("res://sounds/fall.ogg", "fall")
				await get_tree().create_timer(2).timeout
				
			get_tree().change_scene_to_file(room)
		else:
			get_tree().reload_current_scene()
		
		
func getMusic(check_area : String) -> String:
	match check_area:
		m_area_null: return "musNone"
		m_area_outside: return "musOutside"
		m_area_final_sub2: return "musOutside"
		m_area_factory: return "musFactory"
		m_area_ruin: return "musRuin"
		m_area_ruin_sub2: return "musRuin"
		m_area_clock: return "musClock"
		m_area_clock_sub1: return "musClock"
		m_area_clock_sub2: return "musClock"
		m_area_lab: return "musLab"
		m_area_final: 
			if progress.power_complete:
				return "musPowerPlantOn"
			else:
				return "musPowerPlantOff"
		m_area_final_sub3: return "musPowerPlantOn"
		m_area_cave: return "musCave"
		m_area_deeplab: return "musPowerPlantOff"
			
	return "musNone"



func save_game() -> void:
	progress_set("last_area", area)
	progress_set("last_room_x", roomtargetx)
	progress_set("last_room_y", roomtargety)
	progress_set("last_room_dir", roomtargetfacing)
	progress_set("last_room_state", roomtargetstate)
	
	save_progress()
	save_stats()
	
func load_game() -> void:
	load_progress()
	load_stats()


func show_textbox(file : String = "test", node : String = "text") -> void:
	if get_tree().get_node_count_in_group("text") < 1:
		get_tree().paused = true
		var box : Node = load("res://ui/textbox.tscn").instantiate()
		box.set_text(file, node)
		get_tree().root.add_child(box)
		await box.text_finished
		#emit_signal("cutscene_finished")
		get_tree().paused = false


func kill_text() -> void:
	get_tree().call_group("text", "queue_free")
	
	
func set_playing() -> void:
	if !playing:
		playing = true
		playing_timer = Timer.new()
		playing_timer.one_shot = false
		playing_timer.process_mode = Node.PROCESS_MODE_ALWAYS
		playing_timer.connect("timeout", increment_playtime)
		add_child(playing_timer)
		playing_timer.start()
		
		
func stop_playing() -> void:
	if playing:
		playing = false
		if playing_timer != null:
			playing_timer.queue_free()
		
func increment_playtime() -> void:
	progress["time_sec"] += 1

func _on_device_changed(device: String, _device_index: int) -> void:
	print(device)
	current_device = device
	emit_signal("device_changed", device)


func reset() -> void:
	progress = default_progress.duplicate(true)
	Game.roomtargetstate = Game.PLAYERSTATE.CUTSCENE
	Game.roomtargetfacing = Game.PLAYERDIR.DOWN
	Game.roomtargetx = 0
	Game.roomtargety = 0


func lower_gates() -> void:
	progress["gates_down"] = true
	emit_signal("gates_lowered")
	Audio.play_sound("res://sounds/sndGate.ogg", "gate_down")


func start_clock_timer() -> void:
	if !clock_counting and !progress.clock_complete:
		clock_counting = true
		clock_timer = Timer.new()
		clock_timer.one_shot = false
		clock_timer.process_mode = Node.PROCESS_MODE_PAUSABLE
		clock_timer.connect("timeout", decrement_clocktime)
		add_child(clock_timer)
		clock_timer.start()
		add_clock_ui(false)
		
func stop_clock_timer() -> void:
	if clock_counting:
		clock_counting = false
		if clock_timer != null:
			clock_timer.queue_free()
		if clock_ui != null:
			clock_ui.queue_free()

func decrement_clocktime() -> void:
	Game.progress.towertime_left -= 1
	if Game.progress.towertime_left < 0:
		stop_clock_timer()
		transition_room("res://rooms/rmClockTimeup.tscn")
	
	
func add_clock_ui(intro_anim := false) -> void:
	if clock_ui == null:
		clock_ui = load("res://ui/clock_ui.tscn").instantiate()
		clock_ui.play_intro = intro_anim
		add_child(clock_ui)
		print("added")


func get_input_sprite() -> String:
	if current_device == InputHelper.DEVICE_KEYBOARD:
		return "Space or Z"
	else:
		return "[img]res://sprites/input/ButtonAGeneric.png[/img]"
