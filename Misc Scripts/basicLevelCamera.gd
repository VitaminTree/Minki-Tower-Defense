class_name LevelCamera extends Camera2D

@export var animation_player: AnimationPlayer

@export_category("Camera Boundary")
@export var UL: Marker2D 
@export var LR: Marker2D

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


func transition(animation_name: String) -> void:
	if not animation_player:
		print("AnimationPlayer not set")
		return
	if not animation_player.has_animation(animation_name):
		print("Could not find animation with name: \"$s\"" % animation_name)
		return
	animation_player.play(animation_name)
	await animation_player.animation_finished
	SignalMessenger.CLEAR_OOB_TOWERS.emit()
	
	
