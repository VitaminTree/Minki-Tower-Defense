extends Node2D


@onready var wispBasic = preload("res://Enemies/Wisp.tscn")
@onready var dragoonBasic = preload("res://Enemies/Dragoon.tscn")
@onready var label = $"../CurrentWaveLabel"

var nextWave: int = 1
var pathIndex: int = 0


func _on_next_level_button_pressed() -> void:
	match nextWave:
		1:
			wave_one()
		2:
			wave_two()
		3:
			wave_three()
		4:
			wave_four()
		_:
			label.text = "Winner is you!"
	nextWave += 1


func summon_distributed(seconds: float, summon: PackedScene) -> void:
	# Get a referrence to one of the level's path
	var child_path = get_child(pathIndex)
	# Set a timer and wait for it to end
	get_node("Timer").start(seconds)
	await get_node("Timer").timeout
	# Add PathFollow node for the enemy to use
	var route = PathFollow2D.new()
	route.rotates = false
	route.loop = false
	child_path.add_child(route)
	# Make an enemy and attach it to the PathFollow we just created, the last PathFollow in the Tree.
	var temp = summon.instantiate()
	var pathFollowCount = child_path.get_child_count()
	child_path.get_child(pathFollowCount-1).add_child(temp)
	# If the level has multiple paths, increment pathIndex so it'll point to a different one for next time
	pathIndex = (pathIndex+1)%(get_child_count()-1)


func wave_one() -> void:
	label.text = "Wave 1 of 4"
	for i in 10:
		await summon_distributed(1, wispBasic)


func wave_two() -> void:
	label.text = "Wave 2 of 4"
	for i in 8:
		await summon_distributed(0.5, dragoonBasic)


func wave_three() -> void:
	label.text = "Wave 3 of 4"
	for i in 5:
		await summon_distributed(0.4, wispBasic)
	for j in 5:
		await summon_distributed(0.4, dragoonBasic)


func wave_four() -> void:
	label.text = "Wave 4 of 4"
	for i in 20:
		await summon_distributed(0.2, wispBasic)
		await summon_distributed(0.2, dragoonBasic)


