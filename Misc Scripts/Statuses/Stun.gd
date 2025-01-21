class_name Stun extends Status

var orignial_speed: int = 0

func _init(time: float = 3.0):
	super._init(time)
	name = "Stun"

func on_apply(target: Node) -> void:
	orignial_speed = target.original_speed
	target.speed = 0

func on_remove(target: Node) -> void:
	target.speed = orignial_speed
