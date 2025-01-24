class_name Telescope extends ItemData

func apply_upgrade(tower: Tower) -> void:
	tower.rangeHitbox.scale *= 1.75
	tower.rangeVisual.scale *= 1.75

# Advisable for towers that manipulate the range to also change the bullet's lifetime
func buff_projectile(_dart: Dart) -> void:
	_dart.timer.wait_time *= 1.75
