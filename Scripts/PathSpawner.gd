extends Node2D


@onready var wispBasic = preload("res://Enemies/Wisp.tscn")
@onready var dragoonBasic = preload("res://Enemies/Dragoon.tscn")
@onready var label = $"../CurrentWaveLabel"
@onready var button = $"../NextLevelButton"

var currentWave: int = 0
var pathIndex: int = 0

@export var totalEnemies: int = 0

@onready
var waves = [
	# When the wave starts, it waits 1 second then spawns a wisp.
	# It will repeat the wait-and-spawn 10 times
	Wave.new([
		Spawn.new(10, 1, [wispBasic]) 
	]),
	# A wave can have multiple Spawns.
	# It will fully resolve the first Spawn before processing the next one.
	Wave.new([
		Spawn.new(5, 0.4, [wispBasic]),
		Spawn.new(5, 0.4, [dragoonBasic])
	]),
	# This wave spawns a group of 5 wisps, then waits 3 seconds for the next group of 5.
	#
	# The spawner takes "repeat" x "interval" x "number of enemies" time in seconds to resolve the Spawn's instruction.
	#
	# For a Gap Spawn:
	# If the first digit is 0, or the array is empty, then the spawner will not wait at all.
	# if the first digit is greater than 1, or there are multiple nulls in the array,
	# then, the spawner will wait for much longer than the Wait time given.
	Wave.new([
		Spawn.new(5, 0.3, [wispBasic]), 
		Spawn.new(1, 3, [null]), 
		Spawn.new(5, 0.3, [wispBasic]),
		Spawn.new(1, 3, [null]), 
		Spawn.new(5, 0.3, [wispBasic])
	]),
	Wave.new([
		Spawn.new(8, 0.5, [dragoonBasic])
	]),
	# When the array has multiple enemies, it will look at the first index, spawn 1 enemy of that type,
	# wait the given delay, then do the same for the next entry.
	# Once it reaches the end of the array, it will repeat this until the array has been fully read
	# the "repeat" number of times
	Wave.new([
		Spawn.new(20, 0.2, [wispBasic, dragoonBasic])
	]),
	# This wave spawns a wisp, a wisp, a dragoon, then repeats the pattern 14 more times
	Wave.new([
		Spawn.new(15, 0.2, [wispBasic, wispBasic, dragoonBasic])
	])
	
	]

func _ready() -> void:
	SignalMessenger.connect("ENEMY_LEFT", on_enemy_removal)

func on_enemy_removal() -> void:
	totalEnemies -= 1
	if totalEnemies < 1:
		button.disabled = false


func count_enemies_in_wave(wave: Wave) -> int:
	var count: int = 0
	for spawn in wave.spawns:
		if spawn.enemies[0]:
			count += ( spawn.enemies.size() * spawn.repeat )
	return count


func _on_next_level_button_pressed() -> void:
	button.disabled = true
	if currentWave >= waves.size():
		label.text = "You win"
	else:
		label.text = "Wave %d of %d" % [(currentWave + 1), waves.size()]
		totalEnemies = count_enemies_in_wave(waves[currentWave])
		summon_wave(waves[currentWave])
		currentWave += 1


func summon_distributed(seconds: float, summon: PackedScene) -> void:
	# Get a referrence to one of the level's path
	var child_path = get_child(pathIndex)
	# Set a timer and wait for it to end
	get_node("Timer").start(seconds)
	await get_node("Timer").timeout
	# Write this down later
	if not summon:
		return
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

