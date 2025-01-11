extends Control

@onready var time = $Timer
@onready var label_dots = $HBoxContainer/Dots
var dotcount: int = 1
var done: bool = false


func _ready() -> void:
	$FileLoader.load_savedata()
	#check_save_data()
	done = true

func _process(_delta) -> void:
	draw_dots()
	if $FakeLoading.is_stopped() and done:
		get_tree().change_scene_to_file("res://UI/Main Menu/MainMenu.tscn")


func check_save_data() -> void:
	if not FileAccess.file_exists("user://SaveGame.save"):
		return
	var save_data = FileAccess.open("user://SaveGame.save", FileAccess.READ)
	
	#while save_data.get_position() < save_data.get_length():
	var json_string = save_data.get_as_text()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result == OK:
		var node_data = json.get_data()
		GameData.load_gamestate(node_data)
	else:
		print("ERROR I guess")


func draw_dots() -> void:
	if time.is_stopped():
		dotcount += 1
		time.start()
	if dotcount > 4:
		dotcount = 1
	var dots: String = ""
	for i in dotcount:
		dots += "."
	label_dots.text = dots
