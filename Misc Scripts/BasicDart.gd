class_name Dart extends Area2D

@onready var timer: Timer = $Timer

@export var speed: float = 1250
@export var penetration: int = 1
@export var dartDamage: float = 1

var direction: Vector2

#Upgrade stuff
var upgrades: Array[ItemData] = []


func _physics_process(delta: float) -> void:
	if timer.is_stopped():
		queue_free()
	translate(direction*speed*delta)
	for item in upgrades:
		if item:
			item.run_projectile_upgrade(self, delta)

func _on_body_entered(body: Node2D) -> void:
	if "enemy" in body.name:
		body.health -= dartDamage
		penetration -= 1
		on_hit_effect(body)
	if penetration <= 0:
		queue_free()

# A basic dart does nothing besides reducing health,
# but darts inherting the basic dart can override to apply extra effects
func on_hit_effect(body: enemy) -> void:
	for item in upgrades:
		if item:
			item.apply_enemy_effect(body)
