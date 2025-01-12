extends Node

var Backpack: Inventory

func _ready() -> void:
	Backpack = Inventory.new()
	clear_inventory()


func clear_inventory() -> void:
	Backpack.slot_datas = []
	for i in 10:
		var slot = SlotData.new()
		Backpack.add_slot(slot)


func load_inventory(data: Dictionary) -> void:
	if not data:
		return
	
	clear_inventory()
	
	for key in data:
		var slot = SlotData.new()
		slot.item_data = GameData.find_item(data[key])
		Backpack.fill_slot(slot)


func save_inventory() -> Dictionary:
	var inventory = {}
	var index: int = 0
	for slot in Backpack.slot_datas:
		if not slot:
			inventory[index] = ""
			index += 1
			continue
		if not slot.item_data:
			inventory[index] = ""
			index += 1
			continue
		inventory[index] = slot.item_data.name
		index += 1
	return inventory
