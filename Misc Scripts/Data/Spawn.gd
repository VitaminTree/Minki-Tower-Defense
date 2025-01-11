class_name Spawn

var repeat : int = 1
var interval : float = 0.5

var enemies : Array[PackedScene] = []

func _init(_repeat : int = 1,
	_interval : float = 0.5,
	_enemies : Array[PackedScene] = []):
	repeat = _repeat
	interval = _interval
	enemies = _enemies
