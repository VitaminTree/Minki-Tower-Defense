extends Panel

const TOWER: int = 3


@export var tower = Tower


@onready var index_one = $HBoxContainer/TextureButton
@onready var index_two = $HBoxContainer/TextureButton2
@onready var index_three = $HBoxContainer/TextureButton3

@onready var backpack = $Backpack



var temp_name: Inventory
var items: Array[Label] = [index_one, index_two, index_three]

func _ready() -> void:
	backpack.tower = tower
	temp_name = Inventory.new()
	temp_name.slot_datas = [null, null, null]
	backpack.update_inventory(temp_name, TOWER)
	SignalMessenger.connect("INVENTORY_UPDATED", update_tower_inventory)


func update_tower_inventory(_inventory_data: Inventory, inventory_type: int) -> void:
	if inventory_type != TOWER:
		return
	print("Something!")
