extends StaticBody2D

@export var dartDamage = 1

var dart = preload("res://Towers/Dart.tscn")
var objectsInRange = []
var target


func _process(_delta: float) -> void:
	if is_instance_valid(target): # If there is a wisp to shoot at, look at it and shoot
		self.look_at(target.global_position)
		if $BulletCooldown.is_stopped(): 
			var tempDart = dart.instantiate()
			tempDart.direction = global_position.direction_to(target.global_position)
			tempDart.dartDamage = dartDamage
			get_node("BulletContainer").add_child(tempDart)
			tempDart.global_position = $BulletOrigin.global_position
			tempDart.look_at(target.global_position)
			# restart the timer 
			$BulletCooldown.start()
	else:
		for i in get_node("BulletContainer").get_child_count(): # Deletes all darts originating from this tower if there is no wisp in range, or if the target wisp died before a new one could be rechosen
			get_node("BulletContainer").get_child(i).queue_free()
		refresh_targets()


func _on_bullet_range_body_entered(_body: Node2D) -> void:
	refresh_targets()


func _on_bullet_range_body_exited(_body: Node2D) -> void:
	refresh_targets()


func refresh_targets() -> void:
	objectsInRange = get_node("BulletRange").get_overlapping_bodies()
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


func _on_timer_timeout() -> void:
	pass
