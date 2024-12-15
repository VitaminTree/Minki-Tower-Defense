extends Sprite2D

func _ready() -> void:
	pass


func _on_water_mouse_entered() -> void:
	SignalMessenger.MOUSE_OVER_WATER.emit(true)
	print("Mouse is over the water")


func _on_water_mouse_exited() -> void:
	SignalMessenger.MOUSE_OVER_WATER.emit(false)
	print("Mouse left the Water")


func _on_path_mouse_entered() -> void:
	SignalMessenger.MOUSE_OVER_PATH.emit(true)
	print("Mouse is over the Path")


func _on_path_mouse_exited() -> void:
	SignalMessenger.MOUSE_OVER_PATH.emit(false)
	print("Mouse left the Path")
