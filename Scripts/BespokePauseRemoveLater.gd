extends Button


@onready var pauseMenu = preload("res://UI/PauseMenu.tscn")

func _ready() -> void:
	pass

func _on_pressed() -> void:
	get_tree().paused = true
	#get_tree().get_root().get_node("Main/UI").visible = false
	
	var pause = pauseMenu.instantiate()
	get_tree().get_root().get_node("Main").add_child(pause)
	
