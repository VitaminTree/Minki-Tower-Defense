extends Sprite2D


func _on_water_mouse_entered() -> void:
	SignalMessenger.MOUSE_OVER_WATER.emit(true)


func _on_water_mouse_exited() -> void:
	SignalMessenger.MOUSE_OVER_WATER.emit(false)


func _on_path_mouse_entered() -> void:
	SignalMessenger.MOUSE_OVER_PATH.emit(true)


func _on_path_mouse_exited() -> void:
	SignalMessenger.MOUSE_OVER_PATH.emit(false)

