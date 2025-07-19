extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Game.progress["lab_complete"] and Game.progress["factory_complete"] and Game.progress["clock_complete"]:
		$DoorSprite.visible = false
		$DoorSpriteOpen.visible = true
		$PanelA.visible = false
		$PanelB.visible = false
		$PanelC.visible = false
		$StaticBodyClosed.queue_free()
		$objInteract.queue_free()
		$FakeTilesB.z_index = 999
	else:
		$StaticBodyOpen.queue_free()
		$DoorSprite.visible = true
		$DoorSpriteOpen.visible = false
		
		if Game.progress["lab_complete"]:
			$PanelA.texture = load("res://sprites/door/sprTabletGlyphLab.png")
		
		if Game.progress["factory_complete"]:
			$PanelB.texture = load("res://sprites/door/sprTabletGlyphFactory.png")
		
		if Game.progress["clock_complete"]:
			$PanelC.texture = load("res://sprites/door/sprTabletGlyphClock.png")
