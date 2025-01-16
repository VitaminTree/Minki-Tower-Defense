extends Node2D

@onready var shop = preload("res://UI/Shops/ItemShop.tscn")

@onready var wispBasic = preload("res://Enemies/Wisp.tscn")
@onready var dragoonBasic = preload("res://Enemies/Dragoon.tscn")
@onready var wispRich = preload("res://Enemies/RichWisp.tscn")
@onready var label = $"../CurrentWaveLabel"
@onready var button = $"../NextLevelButton"

var currentWave: int = 0
var pathIndex: int = 0
var shop_ready: bool = false
@export var totalEnemies: int = 0

@onready
var waves = [
	Wave.new([
		Spawn.new(1, 0, [wispBasic])
	]),
	# When the wave starts, it waits 1 second then spawns a wisp.
	# It will repeat the wait-and-spawn 20 times
	Wave.new([
		Spawn.new(20, 1, [wispBasic]) 
	]),
	Wave.new([
		Spawn.new(30, 0.5, [wispBasic])
	]),
	# A wave can have multiple Spawns.
	# It will fully resolve the first Spawn before processing the next one.
	Wave.new([
		Spawn.new(15, 0.5, [wispBasic]),
		Spawn.new(8, 0.2, [dragoonBasic]),
		Spawn.new(10, 0.5, [wispBasic])
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
	Wave.new([
		Spawn.new(1, 0, [wispRich])
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
	SignalMessenger.connect("SHOP_READY", ready_shop)
	SignalMessenger.connect("ENEMY_LEFT", on_enemy_removal)
	if GameData.NEW_GAME:
		GameData.WavesCleared = currentWave
	else:
		currentWave = GameData.WavesCleared


func wave_completion() -> void:
	GameData.isWaveActive = false
	GameData.WavesCleared = currentWave
	button.disabled = false
	SignalMessenger.SPIRIT_PAYMENT.emit(5)
	if shop_ready == true:
		shop_ready = false
		SignalMessenger.SHOP_SUMMONED.emit()
		get_tree().paused = true
		var shop_menu = shop.instantiate()
		get_tree().get_root().get_node("Main").add_child(shop_menu)
		


func on_enemy_removal() -> void:
	totalEnemies -= 1
	print("Enemies left: %d" % [totalEnemies])
	if totalEnemies < 1:
		SignalMessenger.WAVE_OVER.emit()
		wave_completion()

func ready_shop() -> void:
	shop_ready = true

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
		GameData.isWaveActive = true
		label.text = "Wave %d of %d" % [(currentWave + 1), waves.size()]
		totalEnemies = count_enemies_in_wave(waves[currentWave])
		print("Total enemies: %d" % [totalEnemies])
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

