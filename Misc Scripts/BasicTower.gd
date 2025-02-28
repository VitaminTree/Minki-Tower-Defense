class_name Tower extends StaticBody2D

# Tower data stuff
@export var Name: String
@export var projectile: PackedScene
@export var tags: Array[Tag] = []
# Do not prefill this; Exported for debugging purposes
@export var upgrades: Array[ItemData] = [null, null, null]
var upgradesApplied: Array[bool] = [false,false,false]
var backpack: Inventory
var inventory_created: bool = false 
var type_index: int
var data: TowerData

# Tower's default, unmodified stats
const BASE_PROB: float = 0.01
var BASE_COOLDOWN: float
var BASE_HITBOX_SCALE: Vector2
var BASE_HITBOX_VISUAL_RADIUS: Vector2

var PROB_MULT: float = 1.0

# Where can the tower be placed?
@export_category("Placeable Terrain")
@export var Ground: bool = true
@export var Water: bool = false
@export var Path: bool = false

# References to child nodes
@onready var rangeHitbox: Area2D = $BulletRange
@onready var rangeVisual: Sprite2D = $BulletRangeVisual
@onready var projectileOrigin: Marker2D = $BulletOrigin
@onready var timer: Timer = $BulletCooldown
@onready var contextMenu: Panel = $TowerMenu
@onready var spriteOutline: Sprite2D = $OutlineShader
@onready var equipMenu = $EquipMenu

# For enemy targeting logic
var objectsInRange = []
var target

# For selecting a tower
var selected: bool = false
var hovering: bool = false

func _ready() -> void:
	BASE_COOLDOWN = timer.wait_time
	BASE_HITBOX_SCALE = rangeHitbox.scale
	BASE_HITBOX_VISUAL_RADIUS = rangeVisual.scale
	
	SignalMessenger.connect("TOWER_UPGRADED", update_upgrades)
	#SignalMessenger.connect("TOWER_DOWNGRADED", remove_item)
	set_process_input(false)
	contextMenu.visible = false
	spriteOutline.visible = false
	
	backpack = Inventory.new()
	backpack.slot_datas = [null,null,null]
	equipMenu.update_inventory(backpack, 3)


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


func reset_tower_specs() -> void:
	PROB_MULT = 1.0
	timer.wait_time = BASE_COOLDOWN
	rangeHitbox.scale = BASE_HITBOX_SCALE
	rangeVisual.scale = BASE_HITBOX_VISUAL_RADIUS


func set_data() -> void:
	data = TowerData.new()
	data.Name = Name
	data.slot = type_index
	data.location[0] = int(global_position.x)
	data.location[1] = int(global_position.y)
	data.upgrades = upgrades
	data.upgradecount = upgradesApplied


func attack(tgt: Node2D, atk: PackedScene, origin: Marker2D) -> void:
	if is_instance_valid(tgt):
		var dart = atk.instantiate()
		dart.direction = origin.global_position.direction_to(tgt.global_position)
		#TODO: Have BulletOrigin rotate about the tower w/o having the whole tower rotate. 
		#projectileOrigin.look_at(tgt.global_position) 
		origin.add_child(dart)
		dart.global_position = origin.global_position
		dart.look_at(tgt.global_position)
		
		for item in upgrades:
			if item:
				dart.upgrades.append(item)
				item.buff_projectile(dart)
		
		dart.start()


func refresh_targets(area: Area2D) -> Node2D:
	objectsInRange = area.get_overlapping_bodies()
	var enemiesInRange = []
	
	for i in objectsInRange:
		#if "enemy" in i.name:
		if i.is_in_group("Enemy"):
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


func check_capacity() -> bool:
	for state in upgradesApplied:
		if not state:
			return true
	return false


func update_upgrades() -> void:
	reset_tower_specs()
	upgrades = []
	upgradesApplied = [false, false, false]
	var i: int = 0
	for slot in backpack.slot_datas:
		if slot:
			if slot.item_data:
				slot.item_data.apply_upgrade(self)
				upgrades.append(slot.item_data)
				upgradesApplied[i] = true
				i += 1
				continue
		upgrades.append(null)
		i += 1
	set_data()
	GameData.update_tower_data(data)


# This function appears to trigger second 
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		selected = true
		SignalMessenger.TOWER_UPGRADE_QUERY.emit(backpack, tags)
		rangeVisual.visible = true
		contextMenu.visible = true


# This function appears to trigger first
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not hovering:
			if selected:
				#SignalMessenger.INVENTORY_TOGGLED.emit(self, false)
				selected = false
			rangeVisual.visible = false
			equipMenu.visible = false
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
