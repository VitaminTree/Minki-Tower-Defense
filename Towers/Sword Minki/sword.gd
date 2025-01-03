class_name melee_strike extends Dart

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animationPlayer.play("SwordSwing")
