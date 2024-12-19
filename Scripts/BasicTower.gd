class_name Tower extends Node2D

@export var dartDamage = 1
@export var projectile: PackedScene
@export var projectileContainer: Node
@export var rangeHitbox: Area2D
@export var projectileOrigin: Marker2D
@export var timer: Timer

var objectsInRange = []
var target

# The generic Tower _process function seeks enemies as targets and throws a projectile at it.
# Do not call this if a custom tower:
# 		1. Does not have an attack
#		2. Targets friendly units
#		3. Indescriminately attacks w/o a specified target
# This function may become defunct if certain targets need to be untargetable by default towers
# For example, camoflaged enemies, flying enemies, disguised enemies
func _process(_delta: float) -> void:
	# If the target enemy dies or leaves the range of the tower, look for a new target
	if not is_instance_valid(target):
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
			# All enemies follow a path: All enemies therefore have a PathFollow2D as a parent.
			# If this statement ever becomes untrue, then this line needs to be revised.
			if i.get_parent().get_progress() > furthestTarget.get_parent().get_progress():
				furthestTarget = i
	target = furthestTarget
