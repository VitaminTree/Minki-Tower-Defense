extends Control

@onready var shop_panel = $".."
@onready var item_description_panel = $ItemDescriptionPanel
@onready var animation_player = $AnimationPlayer


func _on_mouse_entered():
	if shop_panel.is_empty:
		return
	animation_player.play("item fade in")


func _on_mouse_exited():
	item_description_panel.hide()
