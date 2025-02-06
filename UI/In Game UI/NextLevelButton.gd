extends Button

var current_wave: int = 1

@onready var current_wave_label = $"../CurrentWaveLabel"


func _ready() -> void:
	SignalMessenger.connect("WAVE_OVER", enable_buttton)	# Doesn't pass an int
	SignalMessenger.connect("NEXT_SECTION_WAVES", enable_buttton) # Does pass an int


func enable_buttton(next_area: int = 0) -> void:
	self.disabled = false
	if next_area:
		current_wave = 1
	else:
		current_wave += 1


func _on_pressed():
	self.disabled = true
	SignalMessenger.WAVE_START.emit()
