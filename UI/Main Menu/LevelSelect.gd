extends CanvasLayer


func _on_icon_01_pressed():
	#GameData.NEW_GAME = true
	#get_tree().paused = false
	GameData.LevelName = "One"
	get_tree().change_scene_to_file("res://UI/Group Select/group_select.tscn")


func _on_icon_02_pressed():
	#GameData.NEW_GAME = true
	#get_tree().paused = false
	GameData.LevelName = "Two"
	get_tree().change_scene_to_file("res://UI/Group Select/group_select.tscn")
