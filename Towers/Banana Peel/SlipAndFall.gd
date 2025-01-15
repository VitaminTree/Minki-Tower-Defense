class_name SlipAndFall extends Dart


func on_hit_effect(body: Node2D) -> void:
	body.apply_status(Flipped.new(2.0))
