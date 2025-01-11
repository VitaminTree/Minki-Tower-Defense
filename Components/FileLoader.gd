class_name Fileloader extends Node

@export var file_path: String = ""

func load_savedata() -> void:
	if not FileAccess.file_exists(file_path):
		return
	var save_data = FileAccess.open(file_path, FileAccess.READ)
	
	#while save_data.get_position() < save_data.get_length():
	var json_string = save_data.get_as_text()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result == OK:
		var node_data = json.get_data()
		GameData.load_gamestate(node_data)
	else:
		print("ERROR I guess")
