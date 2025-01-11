extends Button

# Scene is preloaded to trigger a console error if target file is moved or renamed
@onready var mainMenu = preload("res://UI/Main Menu/MainMenu.tscn")

func _on_pressed() -> void:
	get_tree().paused = false
	GameData.isWaveActive = false
	get_tree().change_scene_to_file("res://UI/Main Menu/MainMenu.tscn")
