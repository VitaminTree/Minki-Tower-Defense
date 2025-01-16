class_name Tower extends StaticBody2D

@export var Name: String
@export var projectile: PackedScene

@export_category("Placeable Terrain")
@export var Ground: bool = true
@export var Water: bool = false
@export var Path: bool = false

@onready var rangeHitbox: Area2D = $BulletRange
@onready var rangeVisual: Sprite2D = $BulletRangeVisual
@onready var projectileOrigin: Marker2D = $BulletOrigin
@onready var timer: Timer = $BulletCooldown
@onready var contextMenu: Panel = $TowerMenu
@onready var spriteOutline: Sprite2D = $OutlineShader
@onready var equipMenu = $EquipMenu

var objectsInRange = []
var target
var selected: bool = false
var hovering: bool = false
var inventory_created: bool = false 
# Every tower will recieve the tower upgraded signal. Therefore, each tower must
# keep a memory of which upgrades have already been applied.
var upgradesApplied: Array[bool] = [false,false,false]
# Do not prefill this; Exported for debugging purposes
@export var upgrades: Array[ItemData] = [null, null, null]
var backpack: Inventory
var data: TowerData

func _ready() -> void:
	SignalMessenger.connect("TOWER_UPGRADED", equip_item)
	SignalMessenger.connect("TOWER_DOWNGRADED", remove_item)
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


func set_data() -> void:
	data = TowerData.new()
	data.Name = Name
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
				item.buff_projectile(dart)


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


#func draw_items() -> void:
#	if upgrades[0]:
#		equipMenu.index_one.texture = upgrades[0].texture
#	if upgrades[1]:
#		equipMenu.index_two.texture = upgrades[1].texture
#	if upgrades[2]:
#		equipMenu.index_three.texture = upgrades[2].texture

# If index is set, the function will attempt to equip the item ONLY in the given index.
func equip_item(item: ItemData, index: int = -1) -> int:
	if not selected:
		return 0
	if not item:
		return 0 
	for i in upgrades.size():
		if index < 0 or i == index:
			if not upgrades[i]:
				upgrades[i] = item
				item.apply_upgrade(self)
				upgradesApplied[i] = true
				set_data()
				GameData.update_tower_data(data)
				return 1
	print("Upgrade limit reached: Item not equiped")
	return 0


func remove_item(index: int) -> void:
	if not selected:
		return
	if not upgrades[index]:
		return
	upgrades[index].remove_upgrade(self)
	upgrades[index] = null
	upgradesApplied[index] = false
	set_data()
	GameData.update_tower_data(data)


func check_capacity() -> bool:
	for state in upgradesApplied:
		if not state:
			return true
	return false


# This function appears to trigger second 
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		rangeVisual.visible = true
		contextMenu.visible = true
		selected = true


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
