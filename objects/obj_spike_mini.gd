extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var area : String = Game.area
	
	if area == Game.m_area_cave:
		$sprite.texture = load("res://sprites/spikes/sprSpikeCave.png")
		
	elif area == Game.m_area_ruin or area == Game.m_area_ruin_sub2:
		$sprite.texture = load("res://sprites/spikes/sprSpikeRuins.png")
		
	elif area == Game.m_area_lab or area == Game.m_area_deeplab:
		$sprite.texture = load("res://sprites/spikes/sprSpikeLab.png")
		
	elif area == Game.m_area_clock or area == Game.m_area_clock_sub1 or area == Game.m_area_clock_sub2:
		$sprite.texture = load("res://sprites/spikes/sprSpikeClock.png")
		
	elif area == Game.m_area_factory:
		$sprite.texture = load("res://sprites/spikes/sprSpikeFactory.png")
		
	elif area == Game.m_area_outside:
		$sprite.texture = load("res://sprites/spikes/sprSpikeOutside.png")
		
	elif area == Game.m_area_final:
		$sprite.texture = load("res://sprites/spikes/sprSpikePower.png")
