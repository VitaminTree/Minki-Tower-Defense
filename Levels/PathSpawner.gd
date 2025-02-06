extends Node2D

@onready var shop = preload("res://UI/Shops/ItemShop.tscn")

@onready var wispBasic = preload("res://Enemies/Wisp.tscn")
@onready var dragoonBasic = preload("res://Enemies/Dragoon.tscn")
@onready var wispRich = preload("res://Enemies/RichWisp.tscn")
@onready var cube = preload("res://Enemies/Cube.tscn")
@onready var pyramid = preload("res://Enemies/Pyramid.tscn")
@onready var sphere = preload("res://Enemies/Sphere.tscn")

@onready var label = $"../CurrentWaveLabel"
@onready var button = $"../NextLevelButton"

@onready var wave_data = $"../WaveData"

var currentSection: int = 1 # index starting at 1 bc "section one" is more natural than "section zero", sue me. 
var currentWave: int = 0
var pathIndex: int = 0
var shop_ready: bool = false
@export var totalEnemies: int = 0


@onready
var waves = [
	Wave.new([
		Spawn.new(1, 0, [wispBasic])
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
	Wave.new([
		Spawn.new(20, 0.8, [dragoonBasic]),
		Spawn.new(15, 0.4, [dragoonBasic]),
		Spawn.new(10, 0.2, [pyramid])
	]),
	Wave.new([
		Spawn.new(1, 0, [sphere]),
		Spawn.new(1, 3, [null]),
		Spawn.new(2, 0.75, [sphere]),
		Spawn.new(10, 0.5, [dragoonBasic]),
		Spawn.new(3, 0.75, [sphere])
	]),
	Wave.new([
		Spawn.new(8, 0.4, [cube, wispBasic, wispBasic,])
	]),
	Wave.new([
		Spawn.new(10, 0.5, [cube]),
		Spawn.new(10, 0.3, [pyramid]),
		Spawn.new(10, 0.2, [pyramid]),
		Spawn.new(4, 0.2, [sphere])
	]),
	Wave.new([
		Spawn.new(1, 0, [wispRich])
	]),
	# When the array has multiple enemies, it will look at the first index, spawn 1 enemy of that type,
	# wait the given delay, then do the same for the next entry.
	# Once it reaches the end of the array, it will repeat this until the array has been fully read
	# the "repeat" number of times
	Wave.new([
		Spawn.new(15, 0.2, [wispBasic, cube, dragoonBasic, pyramid, sphere])
	])
	]

func _ready() -> void:
	SignalMessenger.connect("WAVE_START", _on_next_level_button_pressed)
	SignalMessenger.connect("NEXT_SECTION_WAVES", set_current_section)
	SignalMessenger.connect("SHOP_READY", ready_shop)
	SignalMessenger.connect("ENEMY_LEFT", on_enemy_removal)
	if GameData.NEW_GAME:
		GameData.WavesCleared = currentWave
	else:
		currentWave = GameData.WavesCleared

func set_current_section(section: int) -> void:
	currentSection = section
	currentWave = 0

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
	var section_waves = wave_data.wave_table[currentSection-1]
	if currentWave >= section_waves.size():
		label.text = "You win"
	else:
		GameData.isWaveActive = true
		label.text = "Wave %d of %d" % [(currentWave + 1), section_waves.size()]
		totalEnemies = count_enemies_in_wave(section_waves[currentWave])
		print("Total enemies: %d" % [totalEnemies])
		summon_wave(section_waves[currentWave])
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


func summon_specific(seconds: float, summon: PackedScene, route: Path2D) -> void:
	get_node("Timer").start(seconds)
	await get_node("Timer").timeout
	if not summon:
		return
	var route_follow = PathFollow2D.new()
	route_follow.rotates = false
	route_follow.loop = false
	route.add_child(route_follow)
	var mob = summon.instantiate()
	var mobCount = route.get_child_count()
	route.get_child(mobCount-1).add_child(mob)

func summon_wave(wave: Wave) -> void:
	
	for spawn in wave.spawns:
		for i in range(spawn.repeat):
			for enemy in spawn.enemies:
				#await summon_distributed(spawn.interval, enemy)
				await summon_specific(spawn.interval, enemy, wave_data.path_table[currentSection-1][0])

