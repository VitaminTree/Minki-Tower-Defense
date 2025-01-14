class_name TowerBackpack extends Backpack

@export var tower: Tower

func update_inventory(backpack_data: Inventory, slot_type: int = 0) -> void:
	if slot_type != StorageType:
		return
	if tower:
		if tower.selected or not tower.inventory_created:
			super.update_inventory(backpack_data, slot_type)
			tower.inventory_created = true
	else:
		print("No tower?")
