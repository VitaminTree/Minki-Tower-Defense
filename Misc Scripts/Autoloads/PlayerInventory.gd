extends Node

var Backpack: Inventory

func _ready() -> void:
	Backpack = Inventory.new()
	Backpack.slot_datas = []


func clear_inventory() -> void:
	Backpack.slot_datas = []


func load_inventory(data: Dictionary) -> void:
	if not data:
		return
	
	for key in data:
		var slot = SlotData.new()
		slot.item_data = GameData.find_item(data[key])
		Backpack.add_item(slot)


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
