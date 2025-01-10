extends PanelContainer

@onready var texture_rect = $MarginContainer/TextureRect
@onready var price_label = $PriceLabel
var price: int = 0

signal SHOP_ITEM_CLICKED(index: int)


func set_slot_data(slot_data: SlotData) -> void:
	var item_data = slot_data.item_data
	texture_rect.texture = item_data.texture
	tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
	price = item_data.price
	price_label.text = "$%s" % [item_data.price]
	price_label.show()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if GameData.money >= price:
			SHOP_ITEM_CLICKED.emit(get_index())
		else:
			print("Can't afford that")
