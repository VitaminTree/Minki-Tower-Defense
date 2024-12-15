extends Area2D

@export var speed = 200
var direction
var dartDamage 


func _physics_process(delta: float) -> void:
	translate(direction*speed*delta)

func _on_body_entered(body: Node2D) -> void:
	if "enemy" in body.name:
		body.health -= dartDamage
		queue_free() 
