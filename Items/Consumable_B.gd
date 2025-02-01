class_name ConsumableB extends ItemData

func use_item() -> bool:
	SignalMessenger.TOWER_LIMIT_UPGRADED.emit(2)
	print("B is for bread, sourdough is my favorite")
	return true
