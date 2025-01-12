class_name InventorySlot extends Slot

# Note: "type" is as enum value dictated by the type of slot it's supposed to see.
# for specific values and what they represent, see the parent Slot class
signal INVENTORY_ITEM_CLICKED(index: int, button: int)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		INVENTORY_ITEM_CLICKED.emit(get_index(), event.button_index)
