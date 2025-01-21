class_name Level extends Node2D

@onready var tower_node = $Towers
@export var level_name = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameData.LevelName = level_name
	if not GameData.NEW_GAME:
		load_towers()
	else:
		PlayerInventory.clear_inventory()
		SignalMessenger.INVENTORY_UPDATED.emit(PlayerInventory.Backpack, 0) # 0 => Player type
		GameData.towers = []


func load_towers() -> void:
	for tower in GameData.towers:
		var path = load(GameData.TOWER_REFERENCES[tower.Name])
		var current_tower = path.instantiate()
		
		tower_node.add_child(current_tower)
		
		current_tower.position.x = tower.location[0]
		current_tower.position.y = tower.location[1]
		var i: int = 0
		current_tower.selected = true
		for item in tower.upgrades:
			var slot_data = SlotData.new()
			slot_data.item_data = item
			current_tower.backpack.set_slot(slot_data, i)
			current_tower.equip_item(item)
			SignalMessenger.INVENTORY_UPDATED.emit(current_tower.backpack, 3)
			i += 1
		
		current_tower.selected = false
		current_tower.set_data()
		
		current_tower.get_node("Area").hide()
		current_tower.get_node("BulletRangeVisual").hide()
