extends Panel

@export var price: int = 250

@onready var tower = preload("res://Towers/IceMinki.tscn")
@onready var green: StyleBoxFlat = preload("res://validPlacement.tres")
@onready var red: StyleBoxFlat = preload("res://InvalidPlacement.tres")


var currentTile: Node2D
var validClick: bool = false # Bugfix: Right mouse button release triggers button_mask == 0. This prevents that action from executing masks that look for that event.
var canPurchase: bool = false
var overWater: bool = false
var overPath: bool = false

func _ready() -> void:
	$VBoxContainer/PriceLabel.text = str(price)
	SignalMessenger.connect("BALANCE_UPDATED", can_afford)
	SignalMessenger.connect("MOUSE_OVER_WATER", toggle_water)
	SignalMessenger.connect("MOUSE_OVER_PATH", toggle_path)
	SignalMessenger.MONEY_PAYMENT.emit(0) # hack to check balance at game start

func can_afford(balance: int)-> void:
	canPurchase = balance >= price


func toggle_water(state: bool) -> void:
	overWater = state


func toggle_path(state: bool) -> void:
	overPath = state


func _on_gui_input(event: InputEvent) -> void:
	var tempTower = tower.instantiate()
	tempTower.visible = false
	
	if event is InputEventMouseButton and event.button_mask == 1 and canPurchase: # left mouse button click
		validClick = true
		add_child(tempTower)
		tempTower.process_mode = Node.PROCESS_MODE_DISABLED
	
	elif event is InputEventMouseMotion and event.button_mask == 1: # left mouse button click and drag
		if get_child_count() > 1:
			get_child(1).global_position = event.global_position
			if event.global_position.x > 1640:
				get_child(1).visible = false
			else:
				get_child(1).visible = true
			if not overPath and not overWater:
				get_child(1).get_node("Area").add_theme_stylebox_override("panel", green)
			else:
				get_child(1).get_node("Area").add_theme_stylebox_override("panel", red)
	
	elif event is InputEventMouseButton and event.button_mask == 0: # left OR right mouse button release
		if get_child_count() > 1:
			get_child(1).queue_free()
		if event.global_position.x < 1640 and validClick and not overWater and not overPath:
			
			tempTower.visible = true
			var path = get_tree().get_root().get_node("Main/Towers")
			
			path.add_child(tempTower)
			tempTower.global_position = event.global_position
			tempTower.get_node("Area").hide()
			tempTower.get_node("BulletRangeVisual").hide()
			
			SignalMessenger.MONEY_PAYMENT.emit(-1*price)
			
			validClick = false
	
	else:
		if get_child_count() > 1:
			get_child(1).queue_free()

