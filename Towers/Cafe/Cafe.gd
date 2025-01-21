class_name Cafe extends Tower

var probability: float = BASE_PROB * 20 * PROB_MULT
var ITEM_REF = GameData.ALL_ITEMS

@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	super._ready()
	SignalMessenger.connect("WAVE_OVER", make_items)
	$Label.visible = false

# Empty function intentonally disables the Basic Tower routine
func _process(_delta: float) -> void:
	pass

func make_items() -> void:
	var count: int = 0
	for i in GameData.spirit:
		var roll = randf()
		if roll < probability:
			var random_number = randi() % ITEM_REF.size()
			var slot = SlotData.new
			slot = ITEM_REF.slot_datas[random_number]
			PlayerInventory.Backpack.fill_slot(slot)
			count += 1
	if count > 0:
		SignalMessenger.INVENTORY_UPDATED.emit(PlayerInventory.Backpack, 0)
		$AnimationPlayer.play("item created")
		
