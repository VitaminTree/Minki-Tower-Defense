extends Button

@onready var preview = $"../../Preview"
@onready var levels = $"../../LevelSelect"

const maps = {
	"One" : "res://Levels/Level_01.tscn",
	"Two" : "res://Levels/Level_02.tscn",
	"Three" : "res://Levels/Level_03.tscn"
}

func _ready() -> void:
	if GameData.NEW_GAME:
		print("no save found")
		disabled = true
		preview.visible = false
	else:
		print("save found")
		disabled = false
		preview.visible = true


func _on_continue_button_pressed():
	get_tree().paused = false
	$Fileload.load_savedata()
	get_tree().change_scene_to_file(maps[GameData.LevelName])


func _on_new_game_button_pressed():
	preview.hide()
	levels.show()


func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://UI/Main Menu/OptionsMenu.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
