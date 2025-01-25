extends Button

@export var energy_requirement: int = 2
var empowerment: int = 0
var available: int = 5
	
func _ready() -> void:
	SignalMessenger.connect("SPIRIT_UPDATED", set_available)
	SignalMessenger.connect("SHOP_SUMMONED", reset_button)
	if not GameData.NEW_GAME:
		empowerment = GameData.shop_progress
		available = GameData.spirit
		update()

func set_available(balance: int) -> void:
	available = balance

func reset_button() -> void:
	text = "Summon Shop (0/2)"
	empowerment = 0

# Seperated bc it's posssible to update w/o paying via loading
func update() -> void:
	text = "Summon Shop (%d/2)" % [empowerment]
	if empowerment >= energy_requirement:
			SignalMessenger.SHOP_READY.emit()

func _on_pressed():
	if available > 0:
		SignalMessenger.SPIRIT_PAYMENT.emit(-1)
		empowerment += 1
		GameData.shop_progress = empowerment
		update()
		
