extends Button

@onready var preview = $"../../Preview"
@onready var levels = $"../../LevelSelect"

const maps = {
	"One" : "res://Level_01.tscn",
	"Two" : "res://Level_02.tscn"
}

func _ready() -> void:
	if GameData.NEW_GAME:
		disabled = true
		preview.hide()
	else:
		disabled = false
		preview.show()


func _on_continue_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(maps[GameData.LevelName])


func _on_new_game_button_pressed():
	preview.hide()
	levels.show()


func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://UI/OptionsMenu.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
