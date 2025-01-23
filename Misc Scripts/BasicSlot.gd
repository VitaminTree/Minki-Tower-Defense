class_name Slot extends PanelContainer

const PLAYER = 0
const SHOP_AQUIRE = 1
const SHOP_DESTROY = 2
const TOWER = 3
enum Inventory_Type { PLAYER , SHOP_AQUIRE , SHOP_DESTROY , TOWER }
@export var StorageType: Inventory_Type

@export var image: TextureRect 
@export var price_label: Label
@export var current_inventory: Inventory

var is_empty: bool = true

func get_slot_type() -> int:
	return StorageType

func set_slot_data(slot_data: SlotData) -> void:
	var item_data = slot_data.item_data
	if not item_data:
		return
	is_empty = false
	if image:
		image.texture = item_data.texture
	#tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
	if price_label:
		price_label.text = "$%s" % [item_data.price]


func _on_gui_input(_event: InputEvent) -> void:
	pass
