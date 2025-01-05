class_name SaveGameJSON
extends Button


func _ready() -> void:
	if GameData.isWaveActive:
		self.disabled = true
		$WaveActiveNotifier.visible = true
		$"../Control".visible = true


func save() -> Dictionary:
	var save_dictionary = {
		"Value" : $"../HSlider".value
	}
	return save_dictionary


func save_game() -> void:
	var save_data = FileAccess.open("user://SaveGame.save", FileAccess.WRITE)
	var json_string = JSON.stringify(GameData.save_gamestate())
	save_data.store_line(json_string)
	save_data.close()
	GameData.NEW_GAME = false

func clear_file() -> void:
	DirAccess.remove_absolute(GameData.SAVE_GAME_PATH)
	GameData.NEW_GAME = true

func load_game() -> void:
	if not FileAccess.file_exists("user://SaveGame.save"):
		print("No save file found")
		return
	var save_data = FileAccess.open("user://SaveGame.save", FileAccess.READ)
	
	#while save_data.get_position() < save_data.get_length():
	var json_string = save_data.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result == OK:
		var node_data = json.get_data()
		#$"../HSlider".value = node_data["Value"]
		print(node_data)
	else:
		print("ERROR I guess")


func _on_pressed():
	clear_file()


func _on_save_game_button_2_pressed():
	load_game()


func _on_ingame_save_pressed():
	save_game()
