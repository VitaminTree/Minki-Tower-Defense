extends Button

var current_wave: int = 1
var total_waves: int = 100

@export var label: Label

@onready var current_wave_label = $"../CurrentWaveLabel"


func _ready() -> void:
	SignalMessenger.connect("WAVE_OVER", enable_buttton)	# Doesn't pass an int
	SignalMessenger.connect("NEXT_SECTION_WAVES", enable_buttton) # Does pass an int
	SignalMessenger.connect("RETURN_WAVE_COUNT", update_label)


func enable_buttton(next_area: int = 0) -> void:
	self.disabled = false
	if next_area:
		current_wave = 1
		self.disabled = false
	else:
		current_wave += 1
		if current_wave > total_waves:
			self.disabled = true


func _on_pressed():
	self.disabled = true
	SignalMessenger.WAVE_START.emit()
	

func update_label(max_waves: int) -> void:
	total_waves = max_waves
	label.announce_wave(current_wave, max_waves)
