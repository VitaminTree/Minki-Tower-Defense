extends Label

func reset() -> void:
	self.text = "Click to begin"

func announce_wave(current: int, total: int) -> void:
	self.text = "Wave %s of %s" % [current, total]
