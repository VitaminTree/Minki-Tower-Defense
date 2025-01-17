extends CanvasLayer


@onready var inventory_panel = $InventoryPanel
@onready var shop_panel = $ShopPanel

@onready var tower_groups = {
	"Bloons" : "res://UI/Shops/TowerShop/BloonsTowerPanels.tscn",
	"Pirates" : "res://UI/Shops/TowerShop/BloonwsTowerPanels.tscn"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	if tower_groups.has(GameData.tower_group):
		var node = load(tower_groups[GameData.tower_group])
		shop_panel.add_child(node.instantiate())
	else:
		print("Misspelled: %s" % GameData.tower_group)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		inventory_panel.visible = !inventory_panel.visible
		SignalMessenger.INVENTORY_TOGGLED.emit()
