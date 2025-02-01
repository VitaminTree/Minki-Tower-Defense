class_name Inventory extends Resource

@export var slot_datas: Array[SlotData]


func slot_clicked(index: int, button: int) -> void:
	SignalMessenger.INVENTORY_PROCESSED.emit(self, index, button)

func shop_slot_clicked(index: int) -> void:
	SignalMessenger.Shop_ITEM_INTERACTED.emit(index)

func shop_discard_clicked() -> void:
	SignalMessenger.SHOP_DISCARD_INTERACTED.emit(self)

func tower_clicked(index: int) -> void:
	SignalMessenger.TOWER_UPGRADE_INTERACTED.emit(self, index)

func sortByID(a: SlotData, b: SlotData) -> bool:
	if not a:
		return false
	if not a.item_data:
		return false
	if not b:
		return true
	if not b.item_data:
		return true
	return a.item_data.ID < b.item_data.ID

func sort() -> void:
	slot_datas.sort_custom(sortByID)

func size() -> int:
	if not slot_datas:
		return 0
	return slot_datas.size()

func size_without_nulls() -> int:
	var count: int = 0
	for slot in slot_datas:
		if slot:
			if slot.item_data:
				count += 1
	return count

# Returns true if there is a slot at the given index that contains a non-null item
# Returns false otherwise
func validate_index(index: int) -> bool:
	if index < 0 or index >= slot_datas.size():
		return false
	if not slot_datas[index]:
		return false
	if not slot_datas[index].item_data:
		return false
	return true

# Appends a new slot into the inventory.
# Returns the index of the new slot if it was added, -1 otherwise
func add_slot(slot_data: SlotData) -> int:
	if slot_data:
		slot_datas.append(slot_data)
		return slot_datas.size()-1
	return -1

# Looks through the list for any entries that are either null or contain a null item.
# Replaces the first entry that was null or contains null, appends itself to the
# end of the list otherwise.
# Returns the index where the slot data was inserted into, -1 if it couldn't 
func fill_slot(slot_data: SlotData, _limit: int = -1) -> int:
	if not slot_data:
		return -1
	if not slot_data.item_data:
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

# Returns the slot data located at a given index
# If index is out of bounds or the entry is null, returns null
func grab_slot(index: int) -> SlotData:
	if index < 0 or index >= slot_datas.size():
		return null
	var slot_data = slot_datas[index]
	if slot_data:
		slot_datas[index] = null
		#SignalMessenger.INVENTORY_UPDATED.emit(self)
		return slot_data
	else:
		return null

# Removes the first instance of a given slot data in the list
# Returns the index where it was located, -1 if no matches found.
func remove_slot(slot_data: SlotData) -> int:
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

# Given a slot data and an index, sets the slotdata at that index to the given slotdata
# Retruns the slotdata that was previously in that position
func set_slot(slot_data: SlotData, index: int) -> SlotData:
	var stored_data = slot_datas[index]
	slot_datas[index] = slot_data
	#SignalMessenger.INVENTORY_UPDATED.emit(self)
	if stored_data:
		return stored_data
	else:
		return null

# returns the ItemData stored in the SlotData at the given index
# if it doesn't exist, returns null
# Unlike the other functions, this is a copy: the item in the list isn't nulled out
func get_item_at_slot(index: int) -> ItemData:
	if not validate_index(index):
		return null
	return slot_datas[index].item_data

func swap_slots(first: int, second: int) -> void:
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

func transfer_slot(_other_inventory: Inventory, _index: int) -> void:
	pass

func use_item(index: int) -> bool:
	if validate_index(index):
		return slot_datas[index].item_data.use_item()
	return false



