extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#SignalMessenger.connect("HELLO_WORLD", say_hello)
	pass

#func say_hello() -> void:
#	print("Hello World!")

func _on_pressed() -> void:
	get_tree().quit()
