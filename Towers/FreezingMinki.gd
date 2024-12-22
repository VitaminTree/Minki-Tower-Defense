class_name FreezingMinki extends Tower


# TODO: Make this tower shoot very fasy, with an angle offset per shot.
# This will make it look like it's shooting a cone of bullets
func attack(tgt: Node2D, atk: PackedScene, origin: Marker2D) -> void:
	var initialAngle: Vector2 = origin.global_position.direction_to(tgt.global_position)
	# get a new angle plus/minus 15 degrees
	var offset: float = deg_to_rad( (randi() % 30) - 15 )
	var dart = atk.instantiate()
	dart.direction = initialAngle.rotated(offset)
	origin.add_child(dart)
	dart.global_position = origin.global_position
	dart.look_at(tgt.global_position)
	dart.rotate(offset)
