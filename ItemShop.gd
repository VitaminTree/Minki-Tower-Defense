extends CanvasLayer

const LIGHT_DISCOUNT_CHANCE: float = 0.2
const HALF_DISCOUNT_CHANCE: float = 0.08
const DEEP_DISCOUNT_CHANCE: float = 0.02
const ITEM_REF = GameData.ALL_ITEMS

@export var inventory: BackpackData

@onready var h_box_container = $HBoxContainer
@onready var panel = preload("res://UI/shop_panel.tscn")

var stock: Array[SlotData] = []

func _ready() -> void:
	stock_shop()
	draw_items()

func stock_shop() -> void:
	stock = []
	for i in 5:
		var random_number = randi() % ITEM_REF.slot_datas.size()
		var chosen_slot_data = ITEM_REF.slot_datas[random_number]
		stock.append(chosen_slot_data)


func draw_items() -> void:
	for item in h_box_container.get_children():
		item.queue_free()
		
	for item in stock:
		var this_panel = panel.instantiate()
		h_box_container.add_child(this_panel) 
		this_panel.connect("SHOP_ITEM_CLICKED", give_item)
		if item:
			this_panel.set_slot_data(item)


func give_item(index: int) -> void:
	var return_value = inventory.add_item(stock[index])
	if return_value >= 0:
		SignalMessenger.MONEY_PAYMENT.emit(-1 * stock[index].item_data.price)
		stock[index] = null
		draw_items()
	else:
		print("Transfer error: Couldn't add that to the backpack")


func _on_button_pressed():
	get_tree().paused = false
	#get_tree().get_root().get_node("Main/UI").visible = true
	queue_free()
