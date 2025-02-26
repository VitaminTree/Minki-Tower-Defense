extends Node

@onready var wispBasic = preload("res://Enemies/Wisp.tscn")
@onready var dragoonBasic = preload("res://Enemies/Dragoon.tscn")
@onready var wispRich = preload("res://Enemies/RichWisp.tscn")
@onready var cube = preload("res://Enemies/Cube.tscn")
@onready var pyramid = preload("res://Enemies/Pyramid.tscn")
@onready var sphere = preload("res://Enemies/Sphere.tscn")

var wave_table = []

@onready
var path_table = [
	[$"../PathSpawner/Section1"]
]

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
	wave_table = [waves]

func get_wave_count(section: int) -> int:
	if section < 0 or section >= wave_table.size():
		return 0
	return wave_table[section].size()
