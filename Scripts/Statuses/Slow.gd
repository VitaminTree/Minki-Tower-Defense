class_name Slow extends Status


func _init(time: float = 3.0):
	super._init(time)
	name = "Slow"

func on_apply(target: Node) -> void:
	target.speed *= 0.2

func on_remove(target: Node) -> void:
	target.speed *= 5.0
