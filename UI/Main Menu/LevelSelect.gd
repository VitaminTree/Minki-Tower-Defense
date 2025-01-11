extends CanvasLayer


func _on_icon_01_pressed():
	GameData.NEW_GAME = true
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Levels/Level_01.tscn")


func _on_icon_02_pressed():
	GameData.NEW_GAME = true
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Levels/Level_02.tscn")
