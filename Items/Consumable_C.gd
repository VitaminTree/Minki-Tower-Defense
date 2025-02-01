class_name ConsumableC extends ItemData

func use_item() -> bool:
	SignalMessenger.TOWER_LIMIT_UPGRADED.emit(3)
	print("C is for carrot, the stuff radar is made of")
	return true
