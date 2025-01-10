extends Button

@export var energy_requirement: int = 2
var empowerment: int = 0
var available: int = 5
	
func ready() -> void:
	SignalMessenger.connect("SPIRIT_UPDATED", set_available)

func set_available(balance: int) -> void:
	available += balance
	if available > 5:
		available = 5
	if available < 0:
		available = 0

func _on_pressed():
	if available > 0:
		SignalMessenger.SPIRIT_PAYMENT.emit(-1)
		empowerment += 1
		text = "Empower Shop (%d/2)" % [empowerment]
		if empowerment >= energy_requirement:
			SignalMessenger.SHOP_READY.emit()
