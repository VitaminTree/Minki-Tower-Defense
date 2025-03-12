extends Node

@onready var wispBasic = preload("res://Enemies/Wisp.tscn")

var wave_table = []

@onready
var path_table = [
	[$"../PathSpawner/Section1"],
	[$"../PathSpawner/Section2"],
	[$"../PathSpawner/Section3_1", $"../PathSpawner/Section3_2"],
	[$"../PathSpawner/Section4_1", $"../PathSpawner/Section4_2"],
	[$"../PathSpawner/Section5_1", $"../PathSpawner/Section5_2"],
]


@onready
var section_one = [
	Wave.new([
		Spawn.new(1, 0, [wispBasic]),
		Spawn.new(5, 1, [wispBasic])
	]),
	Wave.new([
		Spawn.new(1, 0, [wispBasic]),
		Spawn.new(1, 1, [null]),
		Spawn.new(2, 0.25, [wispBasic]),
		Spawn.new(1, 1, [null]),
		Spawn.new(3, 0.25, [wispBasic]),
		Spawn.new(1, 1, [null]),
		Spawn.new(4, 0.25, [wispBasic])
	]),
	Wave.new([
		Spawn.new(12, 0.5, [wispBasic])
	])
	]
@onready
var section_two = [
	Wave.new([
		Spawn.new(1,0,[wispBasic])
	])
	]
var section_three = []
var section_four = []
var section_five = []

func _ready() -> void:
	wave_table = [section_two, section_two, section_two, section_two, section_two]

func get_wave_count(section: int) -> int:
	if section < 0 or section >= wave_table.size():
		return 0
	return wave_table[section].size()
