extends CharacterBody2D

@export var speed = 200
@export var health = 2
@export var damage = 5
@export var payment = 25

func _process(delta: float) -> void:
	var path = get_parent()
	path.set_progress(path.get_progress()+speed*delta)
	if path.get_progress_ratio() == 1:
		SignalMessenger.HEALTH_UPDATE.emit(-1*damage)
		get_parent().queue_free()
	
	if health <= 0:
		SignalMessenger.MONEY_PAYMENT.emit(payment)
		get_parent().queue_free()
