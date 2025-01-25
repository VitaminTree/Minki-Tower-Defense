class_name CoconutTree extends Tower

@onready var animation_player = $AnimationPlayer
@onready var label = $Label

@export var payout: int = 50

func _ready() -> void:
	super._ready()
	SignalMessenger.connect("WAVE_OVER", make_money)
	label.visible = false
	update_payout(payout)

# Empty function intentonally disables the Basic Tower routine
func _process(_delta: float) -> void:
	pass

func make_money() -> void:
	animation_player.play("MoneyGain")
	SignalMessenger.MONEY_PAYMENT.emit(payout)
 
func update_payout(new_value: int) -> void:
	payout = new_value
	label.text = "+$%d" % payout
