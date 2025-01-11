class_name Slot extends PanelContainer

@export var image: TextureRect 
@export var price_label: Label


func set_slot_data(slot_data: SlotData) -> void:
	var item_data = slot_data.item_data
	if image:
		image.texture = item_data.texture
	tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
	if price_label:
		price_label.text = "$%s" % [item_data.price]


func _on_gui_input(_event: InputEvent) -> void:
	pass
