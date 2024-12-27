extends Node2D


@onready var wispBasic = preload("res://Enemies/Wisp.tscn")
@onready var dragoonBasic = preload("res://Enemies/Dragoon.tscn")
@onready var label = $"../CurrentWaveLabel"

var currentWave: int = 0
var pathIndex: int = 0


@onready
var waves = [
	Wave.new([
		Spawn.new(10, 1, [wispBasic])
	]),
	Wave.new([
		Spawn.new(8, 0.5, [dragoonBasic])
	]),
	Wave.new([
		Spawn.new(5, 0.4, [wispBasic]),
		Spawn.new(5, 0.4, [dragoonBasic])
	]),
	Wave.new([
		Spawn.new(20, 0.2, [wispBasic, dragoonBasic])
	])
	
	]



func _on_next_level_button_pressed() -> void:
	if currentWave >= waves.size():
		label.text = "You win"
	else:
		label.text = "Wave %d of %d" % [(currentWave + 1), waves.size()]
		summon_wave(waves[currentWave])
		
		currentWave += 1


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

func summon_wave(wave: Wave) -> void:
	
	for spawn in wave.spawns:
		for i in range(spawn.repeat):
			for enemy in spawn.enemies:
				await summon_distributed(spawn.interval, enemy)

