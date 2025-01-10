class_name InventorySlot extends Slot

signal INVENTORY_ITEM_CLICKED(index: int)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		INVENTORY_ITEM_CLICKED.emit(get_index())
