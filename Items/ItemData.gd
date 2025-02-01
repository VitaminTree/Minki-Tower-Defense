class_name ItemData extends Resource

@export var name: String = ""
@export var ID: int = 0000
@export_multiline var description: String = ""
@export var texture: Texture 
@export var consumable: bool = false
@export var price: int = 100
@export var tags: Array[Tag] = []

# All items technically can be used, but only items that override this i.e. consumables
# actually do anything
func use_item() -> bool:
	return false

# Upgrades that change the tower parameters once
func apply_upgrade(_tower: Tower) -> void:
	pass

# Undoing the changes done to the tower
func remove_upgrade(_tower: Tower) -> void:
	pass

# Upgrades that change the projectile parameters once
func buff_projectile(_dart: Dart) -> void:
	pass

func run_projectile_upgrade(_dart: Dart, _delta: float) -> void:
	pass

func run_tower_upgrade(_tower: Tower, _delta: float) -> void:
	pass

func apply_enemy_effect(_enemy: enemy) -> void:
	pass
