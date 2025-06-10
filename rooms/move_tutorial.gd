extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.connect("device_changed", update_device)
	update_device(Game.current_device)


func update_device(device):
	if Game.options["buttons"] == int(0):
		if device == InputHelper.DEVICE_GENERIC or device == InputHelper.DEVICE_XBOX_CONTROLLER or device == InputHelper.DEVICE_PLAYSTATION_CONTROLLER or device == InputHelper.DEVICE_SWITCH_CONTROLLER or device == InputHelper.DEVICE_STEAMDECK_CONTROLLER:
			$PC.visible = false
			$Gamepad.visible = true
		else:
			$Gamepad.visible = false
			$PC.visible = true
	elif Game.options["buttons"] == int(1):
		$Gamepad.visible = false
		$PC.visible = true
	elif Game.options["buttons"] == int(2):
		$PC.visible = false
		$Gamepad.visible = true
