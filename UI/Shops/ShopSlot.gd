class_name ShopSlot extends Slot

signal SHOP_ITEM_CLICKED(index: int)

func set_slot_data(slot_data: SlotData) -> void:
	super.set_slot_data(slot_data)
	price_label.show()
	price_label.text = "%d" % [slot_data.item_data.price]

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		SHOP_ITEM_CLICKED.emit(get_index())
