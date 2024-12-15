extends Button


func _on_pressed() -> void:
	get_tree().paused = false
	#get_tree().get_root().get_node("Main/UI").visible = true
	
	get_parent().get_parent().queue_free()
