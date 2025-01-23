class_name ShopSlot extends Slot

func set_slot_data(slot_data: SlotData) -> void:
	if not slot_data.item_data:
		return
	super.set_slot_data(slot_data)
	price_label.show()
	price_label.text = "%d" % [slot_data.item_data.price]
	$Control/ItemDescriptionPanel.set_data(slot_data)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		SignalMessenger.SHOP_ITEM_CLICKED.emit(get_index())
