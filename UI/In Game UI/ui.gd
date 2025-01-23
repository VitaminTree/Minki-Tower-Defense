extends CanvasLayer

@onready var tower_panel = preload("res://UI/In Game UI/MinkiShopPanel.tscn")
@onready var inventory_panel = $InventoryPanel
@onready var shop_panel = $ShopPanel/FlowContainer

@onready var tower_groups = {
	"Bloons" : "res://UI/Shops/TowerShop/BloonsTowerPanels.tscn",
	"Pirates" : "res://UI/Shops/TowerShop/BloonwsTowerPanels.tscn"
}

@onready var tower_groups2 = {
	"Bloons" : ["Ice Minki", "Default Minki", "Banana Peel", "Freeze Minki", "Cafe"],
	"Pirates" : ["Sword Minki", "Boat", "Bomb", "Grapeshot", "Coconut Tree"]
}

# Called when the node enters the scene tree for the first time.
func _ready():
	load_slots()
#	if tower_groups.has(GameData.tower_group):
#		var node = load(tower_groups[GameData.tower_group])
#		shop_panel.add_child(node.instantiate())
#	else:
#		print("Misspelled: %s" % GameData.tower_group)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func load_slots() -> void:
	if tower_groups2.has(GameData.tower_group):
		var list = tower_groups2[GameData.tower_group]
		for rook in list:
			var panel = tower_panel.instantiate()
			var tower_ref = load(GameData.TOWER_REFERENCES[rook][0])
			panel.unit = tower_ref
			panel.texture = load(GameData.TOWER_REFERENCES[rook][1])
			shop_panel.add_child(panel)
			ActiveTowers.add_tower(tower_ref.instantiate())
	else:
		print("Misspelled: %s" % GameData.tower_group)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		inventory_panel.visible = !inventory_panel.visible
		SignalMessenger.INVENTORY_TOGGLED.emit()
