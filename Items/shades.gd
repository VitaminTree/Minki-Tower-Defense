class_name shades extends ItemData

func apply_upgrade(tower: Tower) -> void:
	tower.rangeHitbox.scale *= 0.75
	tower.rangeVisual.scale *= 0.75

func remove_upgrade(tower: Tower) -> void:
	tower.rangeHitbox.scale *= 1.33
	tower.rangeVisual.scale *= 1.33

func buff_projectile(dart: Dart) -> void:
	dart.dartDamage *= 2
