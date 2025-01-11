class_name Inventory extends Resource

@export var slot_datas: Array[SlotData]


func slot_clicked(index: int) -> void:
	SignalMessenger.INVENTORY_PROCESSED.emit(self, index)

func add_item(slot_data: SlotData, _limit: int = -1) -> int:
	if not slot_data:
		return -1
	var i: int = 0
	for slot in slot_datas:
		if not slot or not slot.item_data:
			slot_datas[i] = slot_data
			return i
		i += 1
	slot_datas.append(slot_data)
	return i
	# If a max item limit is decided
	# return -1

func remove_item(slot_data: SlotData) -> int:
	if not slot_data:
		return -1
	var index: int = 0
	for slot in slot_datas:
		if slot:
			if slot.item_data == slot_data.item_data:
				slot_datas.remove_at(index)
				return index
		index += 1
	return -1

func swap_items(first: int, second: int) -> void:
	if first < 0 or second < 0:
		return
	if first >= slot_datas.size() or second >= slot_datas.size():
		return
	if first == second:
		return
	if slot_datas[first] == slot_datas[second]:
		return
	var temp_slot: SlotData
	temp_slot = slot_datas[first]
	slot_datas[first] = slot_datas[second]
	slot_datas[second] = temp_slot

func transfer_item(_other_inventory: Inventory, _index: int) -> void:
	pass


#func purchase_slot_data(index: int, balance: int) -> SlotData:
#	var slot_data = slot_datas[index]
#	if not slot_data:
#		return null
#	if balance < 1:
#		return null
#	SignalMessenger.SPIRIT_PAYMENT.emit(-1)
#	slot_datas[index] = null
#	SignalMessenger.INVENTORY_UPDATED.emit(self)
#	return slot_data
