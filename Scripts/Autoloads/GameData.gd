extends Node

# At some point, every relevant resource that's tied to the "player" should probably be in here.
# This includes but is not limited to:
#  - Inventory
#  - Money
#  - Wave progress
#  - Health
#  - Experience? Idk

const ALL_ITEMS = preload("res://UI/Inventory/OneOfEverything.tres")
const SAVE_GAME_PATH = "user://SaveGame.save"
var NEW_GAME: bool = true

# Player Resources
@export var health: int = 1
@export var money: int = 150

# Level advancement
@export var WavesCleared: int = 0
var isWaveActive: bool = false

func find_item(title: String) -> ItemData:
	for item in ALL_ITEMS.slot_datas:
		if item.item_data.name == title:
			return item.item_data
	print("Item \"%d\" was not found. Misspelled?" % [title])
	return null

func save_gamestate() -> Dictionary:
	var resources = {
		"health" : health,
		"money" : money,
		"waves" : WavesCleared
	}
	return resources

func load_gamestate(data: Dictionary) -> void:
	health = data["health"]
	money = data["money"]
	WavesCleared = data["waves"]
	NEW_GAME = false
