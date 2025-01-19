class_name Dice extends ItemData

func apply_upgrade(tower: Tower) -> void:
	tower.probability *= 2.0

func remove_upgrade(tower: Tower) -> void:
	tower.probability *= 0.5
