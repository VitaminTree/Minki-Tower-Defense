extends Button

# Scene is preloaded to trigger a console error if target file is moved or renamed
# WARNING: Because this script is used by the main menu start button AND the game over restart button,
#	the Console throws an error when it tries to run this code (possible cyclic resource inclusion), whatever that means
#	This is likely to resolve itself when the start button is changed to use a different script than the restart button.
#	(Exit button uses this same trick and doesnt throw an error)
#@onready var stageOne = preload("res://main.tscn")
 
# _ready() events are processed top-down in the scene tree.
# If you want something to happen AFTER another node is ready, place it lower in the tree (or use @onready?)
func _ready() -> void:
	if GameData.NEW_GAME:
		text = "New Game"
	else:
		text = "Continue"

func _on_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main.tscn")
