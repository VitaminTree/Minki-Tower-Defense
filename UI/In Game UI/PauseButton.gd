extends Button


@onready var pauseMenu = preload("res://UI/Pause Menu/PauseMenu.tscn")

func _ready() -> void:
	pass

func _on_pressed() -> void:
	SignalMessenger.PAUSE_CLICKED.emit()
	get_tree().paused = true
	#get_tree().get_root().get_node("Main/UI").visible = false
	
	var pause = pauseMenu.instantiate()
	get_tree().get_root().get_node("Main").add_child(pause)
	
