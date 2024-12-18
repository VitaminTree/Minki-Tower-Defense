class_name Tower extends Node2D

@export var dartDamage = 1
@export var projectile: PackedScene
@export var projectileContainer: Node
@export var rangeHitbox: Area2D
@export var projectileOrigin: Marker2D
@export var timer: Timer

var objectsInRange = []
var target


func _process(_delta: float) -> void:
	# Deletes all darts originating from this tower if there is no wisp in range, or if the target wisp died before a new one could be rechosen
	if not is_instance_valid(target):
		for i in projectileContainer.get_child_count(): 
			projectileContainer.get_child(i).queue_free()
		refresh_targets()
		return
	# If there is a wisp to shoot at, look at it and shoot
	#self.look_at(target.global_position)
	if timer.is_stopped(): 
		attack(target)
		timer.start()


func attack(tgt) -> void:
	var dart = projectile.instantiate()
	# global_position of a detached script i.e. a class will return (0,0) regardless of position of inheriting class
	dart.direction = projectileOrigin.global_position.direction_to(target.global_position)
	dart.dartDamage = dartDamage
	#TODO: Have BulletOrigin rotate about the tower w/o having the whole tower rotate. 
	#projectileOrigin.look_at(tgt.global_position) 
	projectileContainer.add_child(dart)
	dart.global_position = projectileOrigin.global_position
	dart.look_at(tgt.global_position)


func refresh_targets() -> void:
	objectsInRange = rangeHitbox.get_overlapping_bodies()
	var enemiesInRange = []
	
	for i in objectsInRange:
		if "enemy" in i.name:
			enemiesInRange.append(i)
	
	target_last(enemiesInRange)


func target_last(enemies: Array) -> void:
	var furthestTarget = null
	for i in enemies:
		if furthestTarget == null:
			furthestTarget = i
		else:
			if i.get_parent().get_progress() > furthestTarget.get_parent().get_progress():
				furthestTarget = i
	target = furthestTarget
