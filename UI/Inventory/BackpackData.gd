class_name BackpackData extends Resource

@export var slot_datas: Array[SlotData]


func slot_clicked(index: int) -> void:
	SignalMessenger.INVENTORY_PROCESSED.emit(self, index)


func purchase_slot_data(index: int, balance: int) -> SlotData:
	var slot_data = slot_datas[index]
	if not slot_data: 
		return null
	if balance < slot_data.item_data.price:
		return null
	SignalMessenger.MONEY_PAYMENT.emit(-1*slot_data.item_data.price)
	slot_datas[index] = null
	SignalMessenger.INVENTORY_UPDATED.emit(self)
	return slot_data
