extends CanvasLayer

const LIGHT_DISCOUNT_CHANCE: float = 0.2
const HALF_DISCOUNT_CHANCE: float = 0.08
const DEEP_DISCOUNT_CHANCE: float = 0.02

const ITEM_REF = GameData.ALL_ITEMS

var stock: Inventory
@onready var inventory_panel = $InventoryPanel


func _ready() -> void:
	stock = Inventory.new()
	SignalMessenger.connect("SHOP_ITEM_CLICKED", give_item)
	stock_shop()


func stock_shop() -> void:
	stock.slot_datas = []
	for i in 5:
		var random_number = randi() % ITEM_REF.slot_datas.size()
		var chosen_slot_data = ITEM_REF.slot_datas[random_number]
		stock.slot_datas.append(chosen_slot_data)
	
	inventory_panel.update_inventory(stock, inventory_panel.StorageType)


func give_item(index: int) -> void:
	var return_value = PlayerInventory.Backpack.fill_slot(stock.slot_datas[index])
	if return_value >= 0:
		SignalMessenger.MONEY_PAYMENT.emit(-1 * stock.slot_datas[index].item_data.price)
		stock.slot_datas[index] = null
		inventory_panel.update_inventory(stock, inventory_panel.StorageType)
		SignalMessenger.INVENTORY_UPDATED.emit(PlayerInventory.Backpack, 0)
	else:
		print("Transfer error: Couldn't add that to the backpack")


func _on_button_pressed():
	get_tree().paused = false
	#get_tree().get_root().get_node("Main/UI").visible = true
	queue_free()
