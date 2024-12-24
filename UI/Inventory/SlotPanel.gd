extends PanelContainer

@onready var texture_rect = $MarginContainer/TextureRect
@onready var price_label = $PriceLabel

signal ITEM_CLICKED(index: int)


func set_slot_data(slot_data: SlotData) -> void:
	var item_data = slot_data.item_data
	texture_rect.texture = item_data.texture
	tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
	price_label.text = "$%s" % [item_data.price]


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		ITEM_CLICKED.emit(get_index())
