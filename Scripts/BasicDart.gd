class_name Dart extends Area2D

@onready var timer: Timer = $Timer

@export var speed: int = 1250
@export var penetration: int = 1

var dartDamage: float = 1
var direction: Vector2
 


func _physics_process(delta: float) -> void:
	if timer.is_stopped():
		queue_free()
	translate(direction*speed*delta)

func _on_body_entered(body: Node2D) -> void:
	if "enemy" in body.name:
		body.health -= dartDamage
		penetration -= 1
	if penetration <= 0:
		queue_free() 
