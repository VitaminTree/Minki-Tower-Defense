extends Panel

@onready var green: StyleBoxFlat = preload("res://validPlacement.tres")
@onready var red: StyleBoxFlat = preload("res://InvalidPlacement.tres")
@onready var container = $FlowContainer

var is_open: bool = false
var hotkey_used: bool = false

var tower_count: int = 0

var held_tower: Tower = null
var held_index: int = -1

var short_pressed: bool = false

var validClick: bool = false 
var validSpot: bool = false
var canPurchase: bool = false
var overWater: bool = false
var overPath: bool = false
var outOfBounds: bool = false

var current: Array = []
var limits: Array = []

func can_afford(balance: int)-> void:
	canPurchase = balance > 0

func toggle_water(state: bool) -> void:
	overWater = state

func toggle_path(state: bool) -> void:
	overPath = state

func toggle_map(state: bool) -> void:
	outOfBounds = state

func _ready() -> void:
	tower_count = container.get_child_count()
	print("towers: %s" % tower_count)
	SignalMessenger.connect("TOWER_PANEL_CLICK_PRESSED", on_panel_click)
	SignalMessenger.connect("TOWER_PANEL_CLICK_RELEASED", on_panel_release)
	SignalMessenger.connect("SPIRIT_UPDATED", can_afford)
	SignalMessenger.connect("MOUSE_OVER_WATER", toggle_water)
	SignalMessenger.connect("MOUSE_OVER_PATH", toggle_path)
	SignalMessenger.connect("TOWER_REMOVED", decrement_slot)
	SignalMessenger.connect("TOWER_ADDED", increment_slot)
	SignalMessenger.connect("TOWER_LIMIT_UPGRADED", upgrade_limit)
	SignalMessenger.connect("MOUSE_OUT_OF_BOUNDS", toggle_map)
	set_process(false)
	SignalMessenger.SPIRIT_PAYMENT.emit(0) # hack to check balance at game start


func _input(event) -> void:
	if event.is_action_pressed("toggle_towers"):
		toggle_visibilty()
	if event.is_action_pressed("hotkey_01"):
		short_pressed = true
		on_panel_click(0)
		return
	if event.is_action_pressed("hotkey_02"):
		short_pressed = true
		on_panel_click(1)
		return
	if event.is_action_pressed("hotkey_03"):
		short_pressed = true
		on_panel_click(2)
		return
	if event.is_action_pressed("hotkey_04"):
		short_pressed = true
		on_panel_click(3)
		return
	if event.is_action_pressed("hotkey_05"):
		short_pressed = true
		on_panel_click(4)
		return
	if event is InputEventMouseButton and held_tower:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			var result = place_tower(get_viewport().get_mouse_position())
			if result:
				print("Placed!")
			elif not is_open:
				toggle_visibilty()
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			clear_held_data()
			print("Canceled!")

# When Active, display the green or red boc over towers, if a tower is being held.
# Try to disable whenever there isn't a tower being held
func _process(_delta):
	held_tower.visible = true
	held_tower.global_position = get_viewport().get_mouse_position()
	if valid_spot(held_tower):
		held_tower.get_node("Area").add_theme_stylebox_override("panel", green)
	else:
		held_tower.get_node("Area").add_theme_stylebox_override("panel", red)


func on_panel_release(index: int, long_click: bool) -> void:
	if canPurchase and current[index] < limits[index]:
		if not long_click:	# Short click release 
			return
		elif held_tower:
			short_pressed = false
			var result = place_tower(get_viewport().get_mouse_position())
			if result:
				print("Dropped!")
			else:
				toggle_visibilty()

func on_panel_click(index: int) -> void:
	if held_tower:
		clear_held_data()
		print("Canceled!")
	if canPurchase and current[index] < limits[index]:
		if is_open:
			toggle_visibilty()
		held_tower = container.get_child(index).unit.instantiate()
		held_index = index
		set_process(true)
		container.get_child(held_index).is_held = true
		container.add_child(held_tower)
		held_tower.process_mode = Node.PROCESS_MODE_DISABLED


func valid_spot(tower: Tower) -> bool:
	var check_ground = tower.Ground and not overPath and not overWater
	var check_water = tower.Water and overWater
	var check_path = tower.Path and overPath
	return (check_ground or check_water or check_path) and not outOfBounds


func clear_held_data() -> void:
	short_pressed = false
	held_tower = null
	container.get_child(held_index).is_held = false
	held_index = -1
	while container.get_child_count() > tower_count:
		var node = container.get_child(tower_count)
		container.remove_child(node)
		node.free()
	set_process(false)


func place_tower(location: Vector2) -> bool:
	print(location)
	if not held_tower:
		print("No tower?")
		return false
	if valid_spot(held_tower):
		var path = get_tree().get_root().get_node("Main/Towers")
		held_tower.position.x = int(held_tower.position.x)
		held_tower.position.y = int(held_tower.position.y)
		held_tower.reparent(path)
		held_tower.type_index = held_index 
		held_tower.set_data()
		GameData.towers.append(held_tower.data)
		held_tower.get_node("Area").hide()
		held_tower.get_node("BulletRangeVisual").hide()
		held_tower.process_mode = Node.PROCESS_MODE_INHERIT
		
		current[held_index] += 1
		draw_slot_flames(held_index)
		SignalMessenger.SPIRIT_PAYMENT.emit(-1)
		clear_held_data()
		return true
	clear_held_data()
	return false


func _on_flow_container_child_entered_tree(_node):
	if not held_tower:
		tower_count += 1
		current.append(0)
		limits.append(1)
		print("new tower count: %s" % tower_count)


func upgrade_limit(index: int, count: int = 1) -> int:
	if index < 0 or index >= limits.size():
		return -1
	limits[index] += count
	draw_slot_flames(index)
	return limits[index]


func decrement_slot(index: int) -> void:
	if index < 0 or index >= current.size():
		print("SIGNAL WARNING (1): slot doesn't exist!")
		return
	current[index] -= 1
	draw_slot_flames(index)

func increment_slot(index: int) -> void:
	if index < 0 or index >= current.size():
		print("SIGNAL WARNING (2): slot doesn't exist!")
		return
	current[index] += 1
	draw_slot_flames(index)

func draw_slot_flames(index: int) -> void:
	container.get_child(index).draw_flames(limits[index], current[index])


func toggle_visibilty():
	if is_open:
		$"../AnimationPlayer".play("Tower Menu Close")
		is_open = false
	else:
		$"../AnimationPlayer".play("Tower Menu Open")
		is_open = true
