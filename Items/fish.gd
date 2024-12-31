class_name fish extends ItemData

func apply_upgrade(_tower: Tower) -> void:
	print("EW")

func buff_projectile(dart: Dart) -> void:
	dart.penetration += 1
