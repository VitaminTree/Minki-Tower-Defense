extends Node

const ALL_ITEMS = preload("res://UI/Inventory/OneOfEverything.tres")

const TOWER_REFERENCES = {
	"Default Minki" : "res://Towers/Default Minki/PurpleMinki.tscn",
	"Ice Minki" : "res://Towers/Circle Attacking Minki/IceMinki.tscn",
	"Freeze Minki" : "res://Towers/Freezing Minki/FreezingMinki.tscn",
	"Sword Minki" : "res://Towers/Sword Minki/ExperimentalMinki.tscn"
}

const SAVE_GAME_PATH = "user://SaveGame.save"
var NEW_GAME: bool = true

# Player Resources
@export var health: int = 1
@export var money: int = 150

# Level advancement
@export var WavesCleared: int = 0
var isWaveActive: bool = false

# Tower information
@export var towers: Array[TowerData] = []

func find_item(title: String) -> ItemData:
	if title == "":
		return null
	for item in ALL_ITEMS.slot_datas:
		if item.item_data.name == title:
			return item.item_data
	print("Item \"%d\" was not found. Misspelled?" % [title])
	return null

func update_tower_data(tower_data: TowerData) -> void:
	for data in towers:
		if data.Name == tower_data.Name:
			if data.location[0] == tower_data.location[0]:
				if data.location[1] == tower_data.location[1]:
					data.upgrades = tower_data.upgrades
					data.upgradecount = tower_data.upgradecount
					return
	print("Couldn't find that tower")

func save_gamestate() -> Dictionary:
	var tower_dict = {}
	var i: int = 0
	for data in towers:
		tower_dict[i] = data.save_data()
		i += 1
	
	var resources = {
		"health" : health,
		"money" : money,
		"waves" : WavesCleared,
		"towers" : tower_dict
	}
	return resources

func load_gamestate(data: Dictionary) -> void:
	health = data["health"]
	money = data["money"]
	WavesCleared = data["waves"]
	
	var tower_data_array: Array[TowerData] = []
	
	var towers_dict = data["towers"]
	for key in towers_dict:
		var tower_data = TowerData.new()
		tower_data.Name = towers_dict[key]["name"]
		tower_data.location[0] = int(towers_dict[key]["position"][0])
		tower_data.location[1] = int(towers_dict[key]["position"][1])
		
		var filler_array: Array[ItemData] = [null, null, null]
		filler_array[0] = find_item(towers_dict[key]["upgrades"]["one"])
		filler_array[1] = find_item(towers_dict[key]["upgrades"]["two"])
		filler_array[2] = find_item(towers_dict[key]["upgrades"]["three"])
		tower_data.upgrades = filler_array
		
		var another_array: Array[bool] = [false, false, false]
		another_array[0] = towers_dict[key]["upgradecount"]["one"] == 1
		another_array[1] = towers_dict[key]["upgradecount"]["two"] == 1
		another_array[2] = towers_dict[key]["upgradecount"]["three"] == 1
		tower_data.upgradecount = another_array
		
		tower_data_array.append(tower_data)
	
	towers = tower_data_array
	
	NEW_GAME = false

