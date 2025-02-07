class_name Level3Camera extends LevelCamera

#@onready var animation_player = $"../AnimationPlayer"

@onready var goto_part_2_button = $"../GOTO Part 2 Button"
@onready var goto_part_3_button = $"../GOTO Part 3 Button"
@onready var goto_part_4_button = $"../GOTO Part 4 Button"
@onready var goto_part_5_from_3_button = $"../GOTO Part 5 from 3 Button"
@onready var goto_part_5_from_4_button = $"../GOTO Part 5 from 4 Button"

var all_buttons: Array = []

func _ready() -> void:
	SignalMessenger.connect("THIS_SECTION_FINISHED", toggle_buttons)
	all_buttons = [
		goto_part_2_button,
		goto_part_3_button,
		goto_part_4_button,
		goto_part_5_from_3_button,
		goto_part_5_from_4_button
		]
	for button in all_buttons:
		button.visible = false

func toggle_buttons() -> void:
	for button in all_buttons:
		button.visible = !button.visible

func _on_goto_part_2_button_pressed():
	SignalMessenger.NEXT_SECTION_WAVES.emit(2)
	transition("transition_1to2")
	toggle_buttons()


func _on_goto_part_3_button_pressed():
	SignalMessenger.NEXT_SECTION_WAVES.emit(3)
	transition("transition_2to3")
	toggle_buttons()


func _on_goto_part_5_from_3_button_pressed():
	SignalMessenger.NEXT_SECTION_WAVES.emit(5)
	transition("transition_3to5")
	toggle_buttons()


func _on_goto_part_5_from_4_button_pressed():
	SignalMessenger.NEXT_SECTION_WAVES.emit(5)
	transition("transition_4to5")
	toggle_buttons()


func _on_goto_part_4_button_pressed():
	SignalMessenger.NEXT_SECTION_WAVES.emit(4)
	transition("transition_1to4")
	toggle_buttons()
