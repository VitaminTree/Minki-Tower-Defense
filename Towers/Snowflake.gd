class_name speedReducingDart extends Dart


# Called when the node enters the scene tree for the first time.
func _init():
	dartDamage = 0.1


func on_hit_effect(body: Node2D) -> void:
	body.apply_status(Slow.new(1.0))
