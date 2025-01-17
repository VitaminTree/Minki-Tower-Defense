extends CanvasLayer

@onready var pirates = preload("res://UI/Group Select/PirateTowers.tscn")
@onready var bloons = preload("res://UI/Group Select/BloonsTowers.tscn")

@onready var list_of_groups = [bloons, pirates]

const maps = {
	"One" : "res://Levels/Level_01.tscn",
	"Two" : "res://Levels/Level_02.tscn"
}

var index = 0
var group_name = "Bloons"

func _ready() -> void:
	$Panel/HBoxContainer/NameLabel.text = ""
	$Panel/HBoxContainer/DescriptionLabel.text = ""

func _on_left_button_pressed():
	var group = get_tree().get_nodes_in_group("Towers")[0]
	group.animation_player.play("Leave_right")
	
	var new_index = (index + 1) % list_of_groups.size()
	index = new_index
 
	var new_group = list_of_groups[index].instantiate()
	group_name = new_group.group_name

	add_child(new_group)
	new_group.animation_player.play("Spawn_left")


func _on_right_button_pressed():
	var group = get_tree().get_nodes_in_group("Towers")
	for node in group:
		node.animation_player.play("Leave_left")
	
	var new_index = (index - 1) % list_of_groups.size()
	if new_index < 0:
		new_index = list_of_groups.size()-1
	index = new_index
	
	
	var new_group = list_of_groups[index].instantiate()
	group_name = new_group.group_name
	
	add_child(new_group)
	new_group.animation_player.play("Spawn_right")


func _on_cancel_button_pressed():
	get_tree().change_scene_to_file("res://UI/Main Menu/MainMenu.tscn")


func _on_start_button_pressed():
	GameData.NEW_GAME = true
	get_tree().paused = false
	GameData.tower_group = group_name
	get_tree().change_scene_to_file(maps[GameData.LevelName])
