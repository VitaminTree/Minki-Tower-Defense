class_name ItemData extends Resource

@export var name: String = ""
@export_multiline var description: String = ""
@export var texture: Texture 
@export var price: int = 100
@export var tags: Array[Tag] = []

func apply_upgrade(_tower: Tower) -> void:
	pass

func remove_upgrade(_tower: Tower) -> void:
	pass
	
func buff_projectile(_dart: Dart) -> void:
	pass


