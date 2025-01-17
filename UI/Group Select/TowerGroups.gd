extends CanvasLayer

@export var group_name: String = ""

@onready var main = $HBoxContainer/Main
@onready var tower_1 = $HBoxContainer/GridContainer/Tower1
@onready var tower_2 = $HBoxContainer/GridContainer/Tower2
@onready var tower_3 = $HBoxContainer/GridContainer/Tower3
@onready var tower_4 = $HBoxContainer/GridContainer/Tower4

@onready var animation_player = $AnimationPlayer

@onready var name_label = $"../Panel/HBoxContainer/NameLabel"
@onready var description_label = $"../Panel/HBoxContainer/DescriptionLabel"


var name_preset = ""
var desc_preset = ""

func _on_main_mouse_entered():
	name_label.text = main.tower_name
	description_label.text = main.description

func _on_tower_1_mouse_entered():
	name_label.text = tower_1.tower_name
	description_label.text = tower_1.description

func _on_tower_2_mouse_entered():
	name_label.text = tower_2.tower_name
	description_label.text = tower_2.description

func _on_tower_3_mouse_entered():
	name_label.text = tower_3.tower_name
	description_label.text = tower_3.description

func _on_tower_4_mouse_entered():
	name_label.text = tower_4.tower_name
	description_label.text = tower_4.description

func on_mouse_exited():
	name_label.text = name_preset
	description_label.text = desc_preset

func leave_scene():
	queue_free()
