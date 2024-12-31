class_name donut extends ItemData

func apply_upgrade(_tower: Tower) -> void:
	print("Hello")

func remove_upgrade(_tower: Tower) -> void:
	print("Goodbye")
	
func buff_projectile(_dart: Dart) -> void:
	print("Dart upgrade attempted")
