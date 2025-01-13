class_name SellSlot extends Slot

signal SHOP_DISCARD_CLICKED


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		SHOP_DISCARD_CLICKED.emit()
