class_name Grapeshot extends Tower

@export var shots = 5


func attack(tgt: Node2D, atk: PackedScene, origin: Marker2D) -> void:
	var initialAngle = origin.global_position.direction_to(tgt.global_position) # (x,y) with values between -1 and 1
	var i = 0
	while i < shots:
		var num1 = (randi() % 40) - 20
		var num2 = (randi() % 40) - 20
		var offset1 = (randi() % 32) - 16
		var offset2 = (randi() % 32) - 16
		
		var angle = deg_to_rad(num1 + num2)
		var dart = atk.instantiate()
		dart.direction = initialAngle.rotated(angle)
		origin.add_child(dart)
		dart.global_position = origin.global_position + Vector2(offset1, offset2)
		
		for item in upgrades:
			if item:
				dart.upgrades.append(item)
				item.buff_projectile(dart)
		
		dart.start()
		
		# Additional penetration instead adds another bullet to each shot
		if dart.penetration > 1:
			if i == 0:
				shots += (dart.penetration -1)
			dart.penetration = 1
		i += 1 
