extends PanelContainer

const Slot = preload("res://UI/Inventory/slot.tscn")
var ITEM_REFERENCES = preload("res://UI/Inventory/OneOfEverything.tres")
var inv_data = preload("res://UI/Inventory/TestInventory.tres")

@onready var item_grid = $MarginContainer/ItemGrid

@export var money: RichTextLabel

var target_tower: Tower

# !! NOTICE !!
# Inventory should be dynamically passed, maybe to a "Player" node?
# For testing purposes, this is OK for now
func _ready() -> void:
	SignalMessenger.connect("INVENTORY_TOGGLED", show_backpack)
	SignalMessenger.connect("INVENTORY_PROCESSED", on_inventory_interact) # likely to need to move to anotehr location, but that's the beauty of using signals
	SignalMessenger.connect("INVENTORY_UPDATED", fill_item_grid)
	fill_item_grid(inv_data)


func fill_item_grid(backpack_data: BackpackData) -> void:
	# Clear the inventory before loading data
	for child in item_grid.get_children():
		child.queue_free()
	
	for slot_data in backpack_data.slot_datas:
		var slot = Slot.instantiate()
		item_grid.add_child(slot)
		
		# Interestingly, I can connect a signal to a parameter's function
		slot.connect("ITEM_CLICKED", backpack_data.slot_clicked)
		
		if slot_data:
			slot.set_slot_data(slot_data)


# Debug function for testing upgrades while a method for aquiring items is unimplemented
func fill_inventory(backpack_data: BackpackData) -> void:
	for i in 20:
		var random_index: int = randi() % ITEM_REFERENCES.slot_datas.size()
		if i < backpack_data.slot_datas.size():
			backpack_data.slot_datas[i] = ITEM_REFERENCES.slot_datas[random_index]
		else:
			backpack_data.slot_datas.append(ITEM_REFERENCES.slot_datas[random_index])


# Debug function for testing upgrades while a method for aquiring items is unimplemented
func empty_inventory(backpack_data: BackpackData) -> void:
	backpack_data.slot_datas = []


func show_backpack(tower: Tower, make_visible: bool) -> void:
	target_tower = tower
	self.visible = make_visible


func on_inventory_interact(backpack_data: BackpackData, index: int) -> void:
	var balance = int(money.text)
	var tower_upgrade_count = target_tower.upgradesApplied
	if tower_upgrade_count < 3:
		var grabbed_slot_data = backpack_data.purchase_slot_data(index, balance)
		print(grabbed_slot_data)
		if grabbed_slot_data:
			target_tower.equip_item(grabbed_slot_data.item_data)
			#target_tower.upgrades.append(grabbed_slot_data.item_data)
			SignalMessenger.TOWER_UPGRADED.emit()
	else:
		print("UPGRADE LIMIT REACHED FOR THIS TOWER")


func _on_add_items_pressed():
	fill_inventory(inv_data)
	fill_item_grid(inv_data)


func _on_remove_items_pressed():
	empty_inventory(inv_data)
	fill_item_grid(inv_data)
