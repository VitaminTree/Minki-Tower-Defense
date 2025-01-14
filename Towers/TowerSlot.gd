class_name TowerSlot extends Slot

signal TOWER_UPGRADE_SLOT_CLICKED(index: int)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		print("Clicked!")
		TOWER_UPGRADE_SLOT_CLICKED.emit(get_index())
