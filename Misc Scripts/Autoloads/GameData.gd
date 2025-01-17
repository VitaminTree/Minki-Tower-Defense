extends Node

const ALL_ITEMS = preload("res://UI/Inventory/OneOfEverything.tres")

const TOWER_REFERENCES = {
	"Default Minki" : "res://Towers/Default Minki/PurpleMinki.tscn",
	"Ice Minki" : "res://Towers/Circle Attacking Minki/IceMinki.tscn",
	"Freeze Minki" : "res://Towers/Freezing Minki/FreezingMinki.tscn",
	"Sword Minki" : "res://Towers/Sword Minki/ExperimentalMinki.tscn",
	"Boat" : "res://Towers/Pirate Ship/Boat.tscn",
	"Bomb" : "res://Towers/Bomb/Bomb.tscn",
	"Banana Peel" : "res://Towers/Banana Peel/BananaPeel.tscn",
	"Coconut Tree" : "res://Towers/Coconut Tree/CoconutTree.tscn",
	"Grapeshot" : "res://Towers/Grapeshot Minki/GrapeshotMinki.tscn",
	"Cafe" : "res://Towers/Cafe/Cafe.tscn"
}

const SAVE_GAME_PATH = "user://SaveGame.save"
var NEW_GAME: bool = true

# Player Resources
@export var health: int = 1
@export var money: int = 150
@export var shop_progress: int = 0
@export var spirit: int = 5

# Level advancement
@export var LevelName: String = "One"
@export var WavesCleared: int = 0
var isWaveActive: bool = false

# Tower information
@export var tower_group: String = "Bloons"
@export var towers: Array[TowerData] = []

func find_item(title: String) -> ItemData:
	if title == "":
		return null
	for item in ALL_ITEMS.slot_datas:
		if item.item_data.name == title:
			return item.item_data
	print("Item \"%d\" was not found. Misspelled?" % [title])
	return null


func find_tower_data_index(tower_data: TowerData) -> int:
	for index in towers.size():
		if towers[index].Name == tower_data.Name:
			if towers[index].location[0] == tower_data.location[0]:
				if towers[index].location[1] == tower_data.location[1]:
					return index
	return -1


func update_tower_data(tower_data: TowerData) -> void:
	var index = find_tower_data_index(tower_data)
	if index > -1:
		towers[index].upgrades = tower_data.upgrades
		towers[index].upgradecount = tower_data.upgradecount
		return
	print("Couldn't find that tower")


func remove_tower(tower_data: TowerData) -> void:
	var index = find_tower_data_index(tower_data)
	if index > -1:
		towers.remove_at(index)
		return
	print("Couldn't Remove that tower from the data list")


func save_gamestate() -> Dictionary:
	var tower_dict = {}
	var i: int = 0
	for data in towers:
		tower_dict[i] = data.save_data()
		i += 1
	
	var resources = {
		"spirit" : spirit,
		"shop" : shop_progress,
		"level" : LevelName,
		"health" : health,
		"money" : money,
		"waves" : WavesCleared,
		"group" : tower_group,
		"towers" : tower_dict,
		"backpack" : PlayerInventory.save_inventory()
	}
	return resources

func load_gamestate(data: Dictionary) -> void: 
	# Check if files have the data first to preserve compatability with older saves
	if data.has("group"):
		tower_group = data["group"]
	if data.has("spirt"):
		spirit = data["spirit"]
	if data.has("level"):
		LevelName = data["level"]
	if data.has("shop"):
		shop_progress = data["shop"]
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
	
	if data.has("backpack"):
		PlayerInventory.load_inventory(data["backpack"])
	
	NEW_GAME = false

