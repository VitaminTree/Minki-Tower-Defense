class_name TowerData extends Resource

@export var Name: String = ""
@export var slot: int = 0
@export var location: Array[int] = [0,0]
@export var upgrades: Array[ItemData] = []
@export var upgradecount: Array[bool] = [false,false,false]

func save_data() -> Dictionary:
	var item_names = ["", "", ""]
	var i: int = 0
	for item in upgrades:
		if item:
			item_names[i] = item.name
		i += 1
	
	var item_dict = {
		"one" : item_names[0],
		"two" : item_names[1],
		"three" : item_names[2]
	}
	
	var upgradecountint = [0,0,0]
	var j: int = 0
	for state in upgradecount:
		if state:
			upgradecountint[j] = 1
		j += 1
	
	var upgrade_dict = {
		"one" : upgradecountint[0],
		"two" : upgradecountint[1],
		"three" : upgradecountint[2]
	}
	
	var dict = {
		"name" : Name,
		"slot" : slot,
		"position" : location,
		"upgrades" : item_dict,
		"upgradecount" : upgrade_dict
	}
	return dict
