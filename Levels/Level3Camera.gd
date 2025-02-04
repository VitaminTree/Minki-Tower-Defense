extends Camera2D

@onready var animation_player = $"../AnimationPlayer"

func _on_goto_part_2_button_pressed():
	SignalMessenger.NEXT_SECTION_WAVES.emit(2)
	animation_player.play("transition_1to2")


func _on_goto_part_3_button_pressed():
	SignalMessenger.NEXT_SECTION_WAVES.emit(3)
	animation_player.play("transition_2to3")


func _on_goto_part_5_from_3_button_pressed():
	SignalMessenger.NEXT_SECTION_WAVES.emit(5)
	animation_player.play("transition_3to5")


func _on_goto_part_5_from_4_button_pressed():
	SignalMessenger.NEXT_SECTION_WAVES.emit(5)
	animation_player.play("transition_4to5")


func _on_goto_part_4_button_pressed():
	SignalMessenger.NEXT_SECTION_WAVES.emit(4)
	animation_player.play("transition_1to4")
