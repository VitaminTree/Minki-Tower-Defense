extends Sprite2D

@onready var UL = $Bounds/UpperLeft
@onready var LR = $Bounds/LowerRight

var out_of_bounds = false

func _process(_delta) -> void:
	var mouse_position = get_viewport().get_mouse_position()
	if mouse_position.x > LR.position.x or mouse_position.y > LR.position.y or mouse_position.x < UL.position.x or mouse_position.y < UL.position.y:
		if not out_of_bounds:
			print("Left the screen")
			SignalMessenger.MOUSE_OUT_OF_BOUNDS.emit(true)
			out_of_bounds = true
	else:
		if out_of_bounds:
			print("Returned to the screen")
			SignalMessenger.MOUSE_OUT_OF_BOUNDS.emit(false)
			out_of_bounds = false
	
func _on_water_mouse_entered() -> void:
	SignalMessenger.MOUSE_OVER_WATER.emit(true)


func _on_water_mouse_exited() -> void:
	SignalMessenger.MOUSE_OVER_WATER.emit(false)


func _on_path_mouse_entered() -> void:
	SignalMessenger.MOUSE_OVER_PATH.emit(true)


func _on_path_mouse_exited() -> void:
	SignalMessenger.MOUSE_OVER_PATH.emit(false)
