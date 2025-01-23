extends CanvasLayer

const SHOP_BUY = 1
const SHOP_SELL = 2

const LIGHT_DISCOUNT_CHANCE: float = 0.2
const HALF_DISCOUNT_CHANCE: float = 0.08
const DEEP_DISCOUNT_CHANCE: float = 0.02

const ITEM_REF = GameData.ALL_ITEMS

var stock: Inventory
var sell: Inventory
@onready var inventory_panel = $BuyContainer
@onready var sell_junk = $SellContainer
@onready var sell_label = $SellLabel

func _ready() -> void:
	stock = Inventory.new()
	SignalMessenger.connect("SHOP_ITEM_CLICKED", give_item)
	SignalMessenger.connect("INVENTORY_UPDATED", update_sell_label)
	stock_shop()
	
	sell = Inventory.new()
	sell.slot_datas = [null]
	#sell_junk.inventory_data = sell
	sell_junk.update_inventory(sell, sell_junk.StorageType)

func stock_shop() -> void:
	stock.slot_datas = []
	for i in 5:
#		var random_number = randi() % ITEM_REF.slot_datas.size()
#		var chosen_slot_data = ITEM_REF.slot_datas[random_number]
		var chosen_slot_data = get_useable_random_item()
		stock.slot_datas.append(chosen_slot_data)
	
	#inventory_panel.inventory_data = stock
	inventory_panel.update_inventory(stock, inventory_panel.StorageType)

func get_useable_random_item() -> SlotData:
	var count: int = 0
	var copy = ITEM_REF.slot_datas.duplicate()
	while count < 200 and copy.size() > 0:
		var slot_data = copy.pick_random()
		if ActiveTowers.tags_match(slot_data.item_data):
			return slot_data
		else:
			copy.erase(slot_data)
			count += 1
	return null


func give_item(index: int) -> void:
	var return_value = PlayerInventory.Backpack.fill_slot(stock.slot_datas[index])
	if return_value >= 0:
		SignalMessenger.MONEY_PAYMENT.emit(-1 * stock.slot_datas[index].item_data.price)
		stock.slot_datas[index] = null
		inventory_panel.update_inventory(stock, inventory_panel.StorageType)
		SignalMessenger.INVENTORY_UPDATED.emit(PlayerInventory.Backpack, 0)
	else:
		print("Transfer error: Couldn't add that to the backpack")


func update_sell_label(inventory_data: Inventory, inventory_type: int) -> void:
	if inventory_type != SHOP_SELL:
		return
	if inventory_data.validate_index(0):
		sell_label.text = "Sells for $%d" % inventory_data.slot_datas[0].item_data.price
	else:
		sell_label.text = "Place item here to sell"


func take_item_for_money() -> void:
	if not sell:
		print("no sell Inventory found")
		return
	var slot = sell.grab_slot(0)
	if not slot:
		print("the first slot is null")
		return
	var item = slot.item_data
	if not item:
		print("the first slot is holding null")
		return
	SignalMessenger.MONEY_PAYMENT.emit(item.price)
	SignalMessenger.INVENTORY_UPDATED.emit(sell, SHOP_SELL)


func _on_button_pressed():
	get_tree().paused = false
	queue_free()


func _on_sell_button_pressed():
	take_item_for_money()


func _on_restock_button_pressed():
	stock_shop()
