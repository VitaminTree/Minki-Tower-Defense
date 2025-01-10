class_name BackpackData extends Resource

@export var slot_datas: Array[SlotData]

func slot_clicked(index: int) -> void:
	SignalMessenger.INVENTORY_PROCESSED.emit(self, index)

func add_item(slot_data: SlotData) -> int:
	if not slot_data:
		return -1
	var i: int = 0
	for slot in slot_datas:
		if not slot:
			slot_datas[i] = slot_data
			return i
		i += 1
	slot_datas.append(slot_data)
	return i
	# If a max item limit is decided
	# return -1


func purchase_slot_data(index: int, balance: int) -> SlotData:
	var slot_data = slot_datas[index]
	if not slot_data:
		return null
	if balance < 1:
		return null
	SignalMessenger.SPIRIT_PAYMENT.emit(-1)
	slot_datas[index] = null
	SignalMessenger.INVENTORY_UPDATED.emit(self)
	return slot_data
