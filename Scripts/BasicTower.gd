class_name Tower extends StaticBody2D

@export var projectile: PackedScene
@export var rangeHitbox: Area2D
@export var projectileOrigin: Marker2D
@export var timer: Timer
@export var contextMenu: Panel
@export var spriteOutline: Sprite2D

var objectsInRange = []
var target
var selected: bool = false
var hovering: bool = false

func _ready() -> void:
	set_process_input(false)
	contextMenu.visible = false
	spriteOutline.visible = false

# The generic Tower _process function seeks enemies as targets and throws a projectile at it.
# 
# This function may become defunct if certain targets need to be untargetable by default towers
# For example, camoflaged enemies, flying enemies, disguised enemies
func _process(_delta: float) -> void:
	# If the target enemy dies or leaves the range of the tower, look for a new target
	refresh_targets(rangeHitbox)
	if not is_instance_valid(target):
		return
	# If there is a wisp to shoot at, shoot
	if timer.is_stopped(): 
		attack(target, projectile, projectileOrigin)
		timer.start()


func attack(tgt: Node2D, atk: PackedScene, origin: Marker2D) -> void:
	if is_instance_valid(tgt):
		var dart = atk.instantiate()
		dart.direction = origin.global_position.direction_to(tgt.global_position)
		#TODO: Have BulletOrigin rotate about the tower w/o having the whole tower rotate. 
		#projectileOrigin.look_at(tgt.global_position) 
		origin.add_child(dart)
		dart.global_position = origin.global_position
		dart.look_at(tgt.global_position)


func refresh_targets(area: Area2D) -> Node2D:
	objectsInRange = area.get_overlapping_bodies()
	var enemiesInRange = []
	
	for i in objectsInRange:
		if "enemy" in i.name:
			enemiesInRange.append(i)
	
	return target_last(enemiesInRange)


func target_last(enemies: Array) -> Node2D:
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
	return target


# This function appears to trigger second 
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		contextMenu.visible = true
		selected = true


# This function appears to trigger first
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not hovering:
			selected = false
			contextMenu.visible = false
			draw_outline()


func _on_mouse_entered():
	hovering = true
	draw_outline()


func _on_mouse_exited():
	hovering = false
	draw_outline()


func draw_outline() -> void:
	if hovering or selected:
		spriteOutline.visible = true
	else:
		spriteOutline.visible = false
