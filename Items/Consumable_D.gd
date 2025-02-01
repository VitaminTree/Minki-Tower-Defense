class_name ConsumableD extends ItemData

func use_item() -> bool:
	SignalMessenger.TOWER_LIMIT_UPGRADED.emit(4)
	print("D is for donuts, the company behind D4DJ Groovy Mix")
	return true
