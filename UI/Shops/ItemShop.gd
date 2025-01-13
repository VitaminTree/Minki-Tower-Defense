extends CanvasLayer

const LIGHT_DISCOUNT_CHANCE: float = 0.2
const HALF_DISCOUNT_CHANCE: float = 0.08
const DEEP_DISCOUNT_CHANCE: float = 0.02

const ITEM_REF = GameData.ALL_ITEMS

var stock: Inventory
var sell: Inventory
@onready var inventory_panel = $BuyContainer
@onready var sell_junk = $SellContainer

func _ready() -> void:
	stock = Inventory.new()
	SignalMessenger.connect("SHOP_ITEM_CLICKED", give_item)
	stock_shop()
	
	sell = Inventory.new()
	sell.slot_datas = [null]
	#sell_junk.inventory_data = sell
	sell_junk.update_inventory(sell, sell_junk.StorageType)

func stock_shop() -> void:
	stock.slot_datas = []
	for i in 5:
		var random_number = randi() % ITEM_REF.slot_datas.size()
		var chosen_slot_data = ITEM_REF.slot_datas[random_number]
		stock.slot_datas.append(chosen_slot_data)
	
	#inventory_panel.inventory_data = stock
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


func take_item_for_money() -> void:
	if not sell:
		print("no sell Inventory found")
		return
	var slot = sell.get_slot(0)
	if not slot:
		print("the first slot is null")
		return
	var item = slot.item_data
	if not item:
		print("the first slot is holding null")
		return
	SignalMessenger.MONEY_PAYMENT.emit(item.price)
	SignalMessenger.INVENTORY_UPDATED.emit(sell, 2)


func _on_button_pressed():
	get_tree().paused = false
	#get_tree().get_root().get_node("Main/UI").visible = true
	queue_free()


func _on_sell_button_pressed():
	take_item_for_money()
