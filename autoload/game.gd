extends Node

const m_surface_takeover = false
const m_devtools = false

const m_debug_overlay = false

const m_area_ruin = "Forgotten Ruins"
const m_area_ruin_sub1 = "The Great Door"
const m_area_cave = "Mysterious Cave"
const m_area_ruin_sub2 = "Ruin Transport Tubes"
const m_area_ruin_sub3 = "Control Room"
const m_area_ruin_sub4 = "Sentry Repair Room"
const m_area_lab = "The Lab"
const m_area_deeplab = "Deep Lab"
const m_area_clock = "The Clock Tower"
const m_area_clock_sub1 = "Maintainence Room"
const m_area_clock_sub2 = "Tower Core"
const m_area_factory = "The Factory"
const m_area_factory_sub1 = "The Package Room"
const m_area_final = "Power Plant"
const m_area_final_sub1 = "Testing Room"
const m_area_final_sub2 = "The End"
const m_area_final_sub3 = "Testing Environments"
const m_area_outside = "The Outside"

const m_area_null = ""

const m_towertimermax = 360*60
const m_total_collectibles = 15
const m_roompicker_limit = 35
const m_transitionspeed = 0.03

const m_sentrycolor_neutral = Color.WHITE
const m_sentrycolor_active = Color.RED
const m_sentryspeed_time = 240

const m_savename = "save.vnd"
const m_configname = "settings.vnd"
const m_devtoolname = "devtools.vnd"
const m_default_musvol = 0.5
const m_default_soundvol = 0.5

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

signal lasers_changed(value)

var roomtargetx : int = 0
var roomtargety : int = 0
var roomtargetfacing : int = 1
var roomtargetstate : PLAYERSTATE = PLAYERSTATE.ALIVE

var safepressureplatepressed : bool = false

var lasers : bool = true:
	set(value):
		lasers = value
		emit_signal("lasers_changed", value)

var beingchased : bool = false
var alert = false

var conveyorspeed = 1
var explosiontime = 0

var showtimer = false

var noclipmode = false
var timeplayedseconds = 0

var usedevtools = false
#check for file

var deaths = 0

var tutorialinteract = true

var collectibles = []

var version = "Version 1.3.0"
var roomtargetarea = "Nonexistent"
var area = roomtargetarea

var labcompleted = false
var deeplabcompleted = false
var clockcompleted = false
var factorycompleted = false
var gatesdeactivated = false
var powerplantcompleted = false

var powerswitchblue = false
var powerswitchgreen = false
var powerswitchyellow = false
var powerswitchred = false

var gamecompleted = false
var besttimeseconds = 100000000

var usescreenshake = true
var soundvol = 0.5
var musvol = 0.5

var tutorialmode = "Autodetect"

var room_width = 320

#Returns a generic death message
func genericDeathMessage():
	return extstd.choose(["Game Over","And it all ended here...","...Then there was darkness","...But it was not over","I love death, don't you?"]);

#Convert seconds into a user-readable string
func getTimeString(seconds : int, usehours : bool = true):
	var minutes : int = seconds/60
	var hours : int = minutes/60
	
	if usehours:
		return str(hours) + ":" + str(minutes%60) + ":" + str(seconds%60)
	else:
		return str(minutes) + ":" + str(seconds%60)


func boolToOnOff(variable : bool):
	if variable:
		return "On"
	else:
		return "Off"
		
		
func checkArea() -> String:
	if get_tree().root.is_in_group("room"):
		return get_tree().root.checkArea()
	
	return m_area_null


func transition_room(room) -> void:
	if room != null:
		
		get_tree().change_scene_to_file(room)
		
		
func getMusic(area) -> String:
	match area:
		m_area_null:
			return "musNone"
		m_area_outside:
			return "musOutside"
		m_area_final_sub2:
			return "musOutside"
		m_area_factory:
			return "musFactory"
		m_area_factory_sub1:
			return "musFactory"
		m_area_ruin:
			return "musRuin"
		m_area_ruin_sub1:
			return "musRuin"
		m_area_ruin_sub2:
			return "musRuin"
		m_area_ruin_sub3:
			return "musRuin"
		m_area_ruin_sub4:
			return "musRuin"
		m_area_clock:
			return "musClock"
		m_area_clock_sub1:
			return "musClock"
		m_area_clock_sub2:
			return "musClock"
		m_area_lab:
			return "musLab"
		m_area_final:
			return "musPowerPlantOff"
		m_area_final_sub1:
			return "musRuin"
		m_area_final_sub3:
			return "musPowerPlantOn"
		m_area_cave:
			return "musCave"
		m_area_deeplab:
			return "musPowerPlantOff"
			
	return "musNone"



func save_game():
	pass
	
	
func load_game():
	pass
