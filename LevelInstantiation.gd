extends Node2D

@onready var tower_node = $Towers

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not GameData.NEW_GAME:
		load_towers()


func load_towers() -> void:
	for tower in GameData.towers:
		var path = load(GameData.TOWER_REFERENCES[tower.Name])
		var current_tower = path.instantiate()
		
		tower_node.add_child(current_tower)
		
		current_tower.position.x = tower.location[0]
		current_tower.position.y = tower.location[1]
		var i: int = 0
		for item in tower.upgrades:
			current_tower.equip_item(item, i)
			SignalMessenger.TOWER_UPGRADED.emit()
			i += 1
		
		current_tower.get_node("Area").hide()
		current_tower.get_node("BulletRangeVisual").hide()
