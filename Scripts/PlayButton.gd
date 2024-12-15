extends Button

# _ready() events are processed top-down in the scene tree.
# If you want something to happen AFTER another node is ready, place it lower in the tree (or use @onready?)
func _ready() -> void:
	#SignalMessenger.HELLO_WORLD.emit() 
	pass

func _on_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main.tscn")
