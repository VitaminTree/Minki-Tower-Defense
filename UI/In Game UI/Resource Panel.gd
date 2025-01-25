extends Panel

@export var Health: int = 150
@export var Money: int = 1000
@export var Spirits: int = 3

var SPIRIT_CAP: int = 3

@onready var hpUI = $HBoxContainer/HealthLabel
@onready var moneyUI = $HBoxContainer/MoneyLabel
@onready var spiritUI = $HBoxContainer/SpiritsContainer
@onready var spiritSprite = preload("res://UI/In Game UI/SpiritIcon.tscn")
@onready var loseMenu = preload("res://UI/GameOverRestart.gd")

func _ready() -> void:
	if GameData.NEW_GAME:
		GameData.health = Health
		GameData.money = Money
		GameData.spirit = Spirits
	else:
		Health = GameData.health
		Money = GameData.money
		Spirits = GameData.spirit
	hpUI.text = str(Health)
	moneyUI.text = str(Money)
	SignalMessenger.connect("MONEY_PAYMENT", update_money)
	SignalMessenger.connect("HEALTH_UPDATE", update_health)
	SignalMessenger.connect("SPIRIT_PAYMENT", update_spirt)
	SignalMessenger.connect("ALL_LIVES_LOST", game_over)

func update_money(amount: int) -> void:
	Money += amount
	moneyUI.text = str(Money)
	GameData.money = Money
	SignalMessenger.BALANCE_UPDATED.emit(Money)

func update_health(amount: int) -> void:
	Health += amount
	hpUI.text = str(Health)
	GameData.health = Health
	if Health <= 0:
		SignalMessenger.ALL_LIVES_LOST.emit()

func update_spirt(amount: int) -> void:
	Spirits += amount
	if Spirits > SPIRIT_CAP:
		Spirits = SPIRIT_CAP
	if Spirits < 0:
		Spirits = 0
	GameData.spirit = Spirits
	SignalMessenger.SPIRIT_UPDATED.emit(Spirits)
	redraw_spirits()

func redraw_spirits() -> void:
	for child in spiritUI.get_children():
		child.queue_free()
	
	for i in Spirits:
		var active_spirit = spiritSprite.instantiate()
		spiritUI.add_child(active_spirit)
	
	for j in (SPIRIT_CAP - Spirits):
		var spent_spirit = spiritSprite.instantiate()
		spent_spirit.material = ShaderMaterial.new()
		var shader = load("res://grayscale.gdshader")
		spent_spirit.material.shader = shader
		spiritUI.add_child(spent_spirit)

func game_over() -> void:
	get_tree().paused = true
	
	var lose = loseMenu.instantiate()
	get_tree().get_root().get_node("Main").add_child(lose)


func _on_add_button_pressed():
	update_spirt(1)


func _on_remove_button_pressed():
	update_spirt(-1)
