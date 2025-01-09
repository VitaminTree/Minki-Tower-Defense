class_name IceMinki extends Tower

# !!! Only implement functions that you intend to overrite basic behavior. !!!

# Multishot attacking in all directions
# At least 1 shot is facing the targeted enemy
func attack(tgt: Node2D, atk: PackedScene, origin: Marker2D) -> void:
	var shots: int = 8
	var initialAngle = origin.global_position.direction_to(tgt.global_position) # (x,y) with values between -1 and 1
	for i in shots:
		var angle = deg_to_rad( 360/float(shots) )*i
		var dart = atk.instantiate()
		dart.direction = initialAngle.rotated(angle)
		origin.add_child(dart)
		dart.global_position = origin.global_position
		dart.look_at(tgt.global_position)
		dart.rotate(angle)
	
		for item in upgrades:
			if item:
				item.buff_projectile(dart)
