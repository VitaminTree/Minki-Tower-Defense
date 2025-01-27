extends Button


@onready var pauseMenu = preload("res://UI/Pause Menu/PauseMenu.tscn")

func _ready() -> void:
	pass

func pause_game() -> void:
	SignalMessenger.PAUSE_CLICKED.emit()
	get_tree().paused = true
	var pause = pauseMenu.instantiate()
	get_tree().get_root().get_node("Main").add_child(pause)
	
func _on_pressed() -> void:
	pause_game()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game"):
		pause_game()
