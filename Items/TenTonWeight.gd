class_name TenTonWeight extends ItemData

var elapsed_delta_time: float = 0.0

func buff_projectile(_dart: Dart) -> void:
	_dart.penetration += 2
	_dart.speed *= 0.5
	_dart.timer.wait_time *= 2.0

func run_projectile_upgrade(_dart: Dart, _delta: float) -> void:
	elapsed_delta_time += _delta
	while elapsed_delta_time > 0.25:
		_dart.dartDamage += 0.5
		elapsed_delta_time -= 0.25 
		print("Damage boosted to %f" % _dart.dartDamage)
