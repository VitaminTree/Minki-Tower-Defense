class_name Level extends Node2D

@onready var tower_node = $Towers
@export var level_name = ""

@export_category("Camera Bounds")
@export var upper_left: Marker2D
@export var lower_right: Marker2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalMessenger.connect("CLEAR_OOB_TOWERS", clear_out_of_bounds_towers)
	GameData.LevelName = level_name
	if not GameData.NEW_GAME:
		load_towers()
	else:
		PlayerInventory.clear_inventory()
		SignalMessenger.INVENTORY_UPDATED.emit(PlayerInventory.Backpack, 0) # 0 => Player type
		GameData.towers = []


func load_towers() -> void:
	for tower in GameData.towers:
		var path = load(GameData.TOWER_REFERENCES[tower.Name][0])
		var current_tower = path.instantiate()
		
		tower_node.add_child(current_tower)
		
		current_tower.position.x = tower.location[0]
		current_tower.position.y = tower.location[1]
		
		current_tower.type_index = tower.slot
		SignalMessenger.TOWER_ADDED.emit(current_tower.type_index)
		
		var i: int = 0
		current_tower.selected = true
		for item in tower.upgrades:
			var slot_data = SlotData.new()
			slot_data.item_data = item
			current_tower.backpack.set_slot(slot_data, i)
			i += 1
		SignalMessenger.INVENTORY_UPDATED.emit(current_tower.backpack, 3)
		SignalMessenger.TOWER_UPGRADED.emit()
		
		current_tower.selected = false
		current_tower.set_data()
		
		current_tower.get_node("Area").hide()
		current_tower.get_node("BulletRangeVisual").hide()

func clear_out_of_bounds_towers() -> void:
	var camera = get_viewport().get_camera_2d().position
	for tower in tower_node.get_children():
		var location = tower.position
		if location.x < camera.x + upper_left.position.x \
			or location.x > camera.x + lower_right.position.x \
			or location.y < camera.y + upper_left.position.y \
			or location.y > camera.y +lower_right.position.y:
			tower.contextMenu._on_sell_button_pressed()
