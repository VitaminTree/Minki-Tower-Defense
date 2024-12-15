extends Panel

@export var Health: int = 250
@export var Money: int = 1000

@onready var hpUI = $HBoxContainer/HealthLabel
@onready var moneyUI = $HBoxContainer/MoneyLabel
@onready var loseMenu = preload("res://GameOverScrren.tscn")

func _ready() -> void:
	hpUI.text = str(Health)
	moneyUI.text = str(Money)
	SignalMessenger.connect("MONEY_PAYMENT", update_money)
	SignalMessenger.connect("HEALTH_UPDATE", update_health)
	SignalMessenger.connect("ALL_LIVES_LOST", game_over)

func update_money(amount: int) -> void:
	Money += amount
	moneyUI.text = str(Money)
	SignalMessenger.BALANCE_UPDATED.emit(Money)

func update_health(amount: int) -> void:
	Health += amount
	hpUI.text = str(Health)
	if Health <= 0:
		SignalMessenger.ALL_LIVES_LOST.emit()

func game_over() -> void:
	get_tree().paused = true
	
	var lose = loseMenu.instantiate()
	get_tree().get_root().get_node("Main").add_child(lose)
