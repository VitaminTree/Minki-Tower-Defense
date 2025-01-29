extends Panel

#@export var price: int = 250
@export var unit: PackedScene
@export var texture: CompressedTexture2D
#
#@onready var green: StyleBoxFlat = preload("res://validPlacement.tres")
#@onready var red: StyleBoxFlat = preload("res://InvalidPlacement.tres")

var is_held: bool = false
var click_holding: bool = false
var time: float = 0.0
#var currentTile: Node2D
# Bugfix: Right mouse button release triggers button_mask == 0. This prevents that action from executing masks that look for that event.
#var validClick: bool = false 
#var validSpot: bool = false
#var canPurchase: bool = false
#var overWater: bool = false
#var overPath: bool = false

func _ready() -> void:
	$VBoxContainer/TextureRect.texture = texture
#	SignalMessenger.connect("SPIRIT_UPDATED", can_afford)
#	SignalMessenger.connect("MOUSE_OVER_WATER", toggle_water)
#	SignalMessenger.connect("MOUSE_OVER_PATH", toggle_path)
	SignalMessenger.SPIRIT_PAYMENT.emit(0) # hack to check balance at game start


#func can_afford(balance: int)-> void:
#	canPurchase = balance > 0
#
#
#func toggle_water(state: bool) -> void:
#	overWater = state
#
#
#func toggle_path(state: bool) -> void:
#	overPath = state

func _process(delta) -> void:
	if not click_holding:	
		return
	time += delta
	

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("Left Mouse Click"):
			# if the manager is holding this panel, do nothing; the Manager must drop this panel first
			if is_held:
				return
			#print("Start!")
			click_holding = true
			SignalMessenger.TOWER_PANEL_CLICK_PRESSED.emit(get_index())
		if event.is_action_released("Left Mouse Click"):
			click_holding = false
			if time < 0.3:
				SignalMessenger.TOWER_PANEL_CLICK_RELEASED.emit(get_index(), false)
			else:
				SignalMessenger.TOWER_PANEL_CLICK_RELEASED.emit(get_index(), true)
			#print("Click released!")
			#print("Time held: %fs\n" % time)
			time = 0.0


#func _on_gui_input(event: InputEvent) -> void:
#	var tempTower = unit.instantiate()
#	tempTower.visible = false
#
#	if event is InputEventMouseButton and event.pressed and canPurchase: # left mouse button click
#		validClick = true
#		add_child(tempTower)
#		tempTower.process_mode = Node.PROCESS_MODE_DISABLED
#
#	# When the window is scaled, event.global_position in this block returns coordinates as if the window were
#	# the original resolution (output is scaled)
#	elif event is InputEventMouseMotion and event.button_mask == 1: # left mouse button click and drag
#		if get_child_count() > 1:
#			get_child(1).global_position = event.global_position
#			if event.global_position.x > 1640:
#				get_child(1).visible = false
#			else:
#				get_child(1).visible = true
#			if (tempTower.Ground and not overWater and not overPath) or (tempTower.Water and overWater) or (tempTower.Path and overPath):
#				validSpot = true
#				get_child(1).get_node("Area").add_theme_stylebox_override("panel", green)
#			else:
#				get_child(1).get_node("Area").add_theme_stylebox_override("panel", red)
#				validSpot = false
#
#	# When the window is scaled, event.global_position in this block returns the absolute coordinates of the 
#	# event location, without any scaling.
#	elif event is InputEventMouseButton and event.button_mask == 0: # left OR right mouse button release
#		if get_child_count() > 1:
#			get_child(1).queue_free()
#
#		var x_ratio: float = get_window().get_size().x / float(1920)
#		if event.global_position.x < 1640 * x_ratio and validClick and validSpot:
#
#			tempTower.visible = true
#			var path = get_tree().get_root().get_node("Main/Towers")
#
#			tempTower.global_position = get_viewport().get_mouse_position()
#			# Convert float positions to ints
#			tempTower.position.x = int(tempTower.position.x)
#			tempTower.position.y = int(tempTower.position.y)
#			path.add_child(tempTower)
#			tempTower.set_data()
#			GameData.towers.append(tempTower.data)
#			tempTower.get_node("Area").hide()
#			tempTower.get_node("BulletRangeVisual").hide()
#
#			SignalMessenger.SPIRIT_PAYMENT.emit(-1)
#
#			validClick = false
#
#	else:
#		if get_child_count() > 1:
#			get_child(1).queue_free()
