class_name ConsumableA extends ItemData

func use_item() -> bool:
	SignalMessenger.TOWER_LIMIT_UPGRADED.emit(1)
	print("A is for apple, a horse's best friend")
	return true
