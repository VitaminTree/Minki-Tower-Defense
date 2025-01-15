class_name  Flipped extends Status

var original_speed: float

func _init(time: float = 3.0):
	super._init(time)
	name = "Flipped"

func on_apply(target: Node) -> void:
	original_speed = target.speed
	target.speed = 0
	target.animation_player.play("Flip")

func on_remove(target: Node) -> void:
	target.speed = original_speed
