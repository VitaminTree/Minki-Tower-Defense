class_name donut extends ItemData

func apply_upgrade(tower: Tower) -> void:
	tower.timer.wait_time *= 0.66

func remove_upgrade(tower: Tower) -> void:
	tower.timer.wait_time *= 1.5
