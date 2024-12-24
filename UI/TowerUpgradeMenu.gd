extends Panel

@onready var index_one = $HBoxContainer/TextureButton
@onready var index_two = $HBoxContainer/TextureButton2
@onready var index_three = $HBoxContainer/TextureButton3

var items: Array[Label] = [index_one, index_two, index_three]
