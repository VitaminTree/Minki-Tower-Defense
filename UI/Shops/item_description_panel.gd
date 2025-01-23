extends Panel

@onready var icon = preload("res://UI/Shops/item_card_tower_icon.tscn")
@onready var item_name = $VBoxContainer/Panel/Label
@onready var item_description = $VBoxContainer/Panel2/Label
@onready var icon_holder = $VBoxContainer/Panel3/HBoxContainer

func _ready() -> void:
	self.hide()

func set_data(slot_data: SlotData) -> void:
	if not slot_data:
		return
	if not slot_data.item_data:
		return
	item_name.text = slot_data.item_data.name
	item_description.text = slot_data.item_data.description
	var towers = ActiveTowers.matches(slot_data.item_data)
	for tower in towers:
		var frame = icon.instantiate()
		var texture = load(GameData.TOWER_REFERENCES[tower][1])
		frame.texture = texture
		icon_holder.add_child(frame)
