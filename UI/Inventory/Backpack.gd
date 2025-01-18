class_name Backpack extends PanelContainer

@onready var Player_Slot = preload("res://UI/Inventory/slot.tscn")
@onready var Shop_Slot = preload("res://UI/Shops/ShopSlot.tscn")
@onready var Shop_Sell_Slot = preload("res://UI/Shops/SellSlot.tscn")
@onready var Tower_Slot = preload("res://Towers/tower_slot.tscn")

const PLAYER = 0
const SHOP_AQUIRE = 1
const SHOP_DESTROY = 2
const TOWER = 3
enum Inventory_Type { PLAYER , SHOP_AQUIRE , SHOP_DESTROY , TOWER }
@export var StorageType: Inventory_Type = Inventory_Type.PLAYER

@export var columns: int = 10

@export var grabbed_slot: Slot
@onready var item_grid = $MarginContainer/ItemGrid

var target_tower: Tower

var grabbed_slot_data: SlotData
var original_index: int


func _ready() -> void:
	item_grid.columns = columns
	SignalMessenger.connect("INVENTORY_TOGGLED", drop_by_signal)
	SignalMessenger.connect("INVENTORY_PROCESSED", on_inventory_interact)
	SignalMessenger.connect("INVENTORY_UPDATED", update_inventory)
	SignalMessenger.connect("PAUSE_CLICKED", drop_grabbed_slot_data)
	SignalMessenger.connect("SHOP_DISCARD_INTERACTED", swap_grabbed_and_sell)
	SignalMessenger.connect("TOWER_UPGRADE_INTERACTED", give_grabbed_to_tower)
	if StorageType == PLAYER:
		if grabbed_slot:
			grabbed_slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
		SignalMessenger.connect("TOWER_UPGRADE_QUERY", attempt_upgrade)
	update_inventory(PlayerInventory.Backpack, PLAYER)


func _physics_process(_delta) -> void:
	if grabbed_slot:
		if grabbed_slot.visible:
			grabbed_slot.global_position = get_global_mouse_position() - Vector2(32,32)


func update_inventory(backpack_data: Inventory, slot_type: int = 0) -> void:
	if slot_type != StorageType:
		return
	
	# Clear the inventory before loading data
	for child in item_grid.get_children():
		child.queue_free()
	
	var count: int = 0
	for slot_data in backpack_data.slot_datas:
		var slot = instantiate_slot(backpack_data, StorageType)
		
		if slot_data and slot:
			slot.set_slot_data(slot_data)
		
		count += 1
	
	if StorageType == PLAYER:
		var number = 10 - count%10
		if number == 10:
			number = 0
		# Repeat the above block a few more times to ensure there's always a full row of slots
		for i in number:
			var slot = instantiate_slot(backpack_data, StorageType)
			var slot_data = SlotData.new()
			if slot:
				slot.set_slot_data(slot_data)
			backpack_data.add_slot(slot_data)


func instantiate_slot(backpack_data: Inventory, _type: int) -> Slot:
	var slot
	match StorageType:
		PLAYER:
			slot = Player_Slot.instantiate()
			item_grid.add_child(slot)
			slot.connect("INVENTORY_ITEM_CLICKED", backpack_data.slot_clicked)
		SHOP_AQUIRE:
			slot = Shop_Slot.instantiate()
			item_grid.add_child(slot)
		SHOP_DESTROY:
			slot = Shop_Sell_Slot.instantiate()
			item_grid.add_child(slot)
			slot.connect("SHOP_DISCARD_CLICKED", backpack_data.shop_discard_clicked)
		TOWER:
			slot = Tower_Slot.instantiate()
			item_grid.add_child(slot)
			slot.connect("TOWER_UPGRADE_SLOT_CLICKED", backpack_data.tower_clicked)
		_:
			print("ERROR: Enum chosen that doesn't exist yet")
			return null
	
	return slot

# Debug function for testing upgrades while a method for aquiring items is unimplemented
func fill_inventory(backpack_data: Inventory) -> void:
	var temp = GameData.ALL_ITEMS
	for i in 3:
		var random_index: int = randi() % temp.slot_datas.size()
		var slot = SlotData.new()
		slot.item_data = temp.slot_datas[random_index].item_data
		backpack_data.fill_slot(slot)


# Debug function for testing upgrades while a method for aquiring items is unimplemented
func empty_inventory(backpack_data: Inventory) -> void:
	backpack_data.slot_datas = []


func drop_by_signal() -> void:
	if StorageType != PLAYER:
		return
	if not self.visible:
		drop_grabbed_slot_data()


func on_inventory_interact(backpack_data: Inventory, index: int, button: int) -> void:
	if StorageType != PLAYER:
		return
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			original_index = index
			grabbed_slot_data = backpack_data.grab_slot(index)
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = backpack_data.set_slot(grabbed_slot_data, index)
	
	update_inventory(backpack_data)
	update_grabbed()


func update_grabbed() -> void:
	if not grabbed_slot:
		return
	if grabbed_slot_data:
		if grabbed_slot_data.item_data:
			# Doing this once before showing the panel eliminates the jump
			grabbed_slot.global_position = get_global_mouse_position() - Vector2(32,32)
			grabbed_slot.show()
			grabbed_slot.set_slot_data(grabbed_slot_data)
			return
	grabbed_slot_data = null
	grabbed_slot.hide()


func drop_grabbed_slot_data() -> void:
	if grabbed_slot_data:
		grabbed_slot_data = PlayerInventory.Backpack.set_slot(grabbed_slot_data, original_index)
		update_grabbed()
		update_inventory(PlayerInventory.Backpack)


func swap_grabbed_and_sell(sell_inventory: Inventory) -> void:
	if StorageType != PLAYER:
		return
	grabbed_slot_data = sell_inventory.set_slot(grabbed_slot_data, 0)
	update_grabbed()
	SignalMessenger.INVENTORY_UPDATED.emit(sell_inventory, SHOP_DESTROY)


func give_grabbed_to_tower(tower_inventory: Inventory, index: int) -> void:
	if StorageType != PLAYER:
		return
	var pre_item = tower_inventory.get_item_at_slot(index)
	if pre_item:
		SignalMessenger.TOWER_DOWNGRADED.emit(index)
	grabbed_slot_data = tower_inventory.set_slot(grabbed_slot_data, index)
	update_grabbed()
	var post_item = tower_inventory.get_item_at_slot(index)
	if post_item:
		SignalMessenger.TOWER_UPGRADED.emit(post_item, index)
	SignalMessenger.INVENTORY_UPDATED.emit(tower_inventory, TOWER)


func attempt_upgrade(inventory_data: Inventory, tags: Array[Tag]) -> void:
	if not grabbed_slot_data:
		print("Not holding an item")
		return
	if not check_held_item(tags):
		print("Tower doesn't have the correct tags to hold this item")
		return
	if inventory_data.size_without_nulls() >= 3:
		print("Tower doesn't have space to hold this item")
		return
	if GameData.spirit <= 0:
		print("Not enough energy to eqip items")
		return
	var index = inventory_data.fill_slot(grabbed_slot_data)
	SignalMessenger.SPIRIT_PAYMENT.emit(-1)
	SignalMessenger.TOWER_UPGRADED.emit(grabbed_slot_data.item_data, index)
	SignalMessenger.INVENTORY_UPDATED.emit(inventory_data, TOWER)
	grabbed_slot_data = null
	update_grabbed()

func check_held_item(tower_tags: Array[Tag]) -> bool:
	if not grabbed_slot_data:
		return false
	if not grabbed_slot_data.item_data:
		return false
	for tag in grabbed_slot_data.item_data.tags:
		if not (tag in tower_tags):
			return false
	return true
		

func stage_slot_for_upgrade(backpack_data: Inventory, index: int) -> SlotData:
	var slot_data = backpack_data.slot_datas[index]
	if not slot_data:
		return null
	if GameData.spirit < 1:
		return null
	SignalMessenger.SPIRIT_PAYMENT.emit(-1)
	backpack_data.slot_datas[index] = null
	SignalMessenger.INVENTORY_UPDATED.emit(backpack_data)
	return slot_data


func _on_add_items_pressed():
	fill_inventory(PlayerInventory.Backpack)
	update_inventory(PlayerInventory.Backpack, StorageType)


func _on_remove_items_pressed():
	empty_inventory(PlayerInventory.Backpack)
	update_inventory(PlayerInventory.Backpack, StorageType)
