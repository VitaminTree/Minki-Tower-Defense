extends Panel

@export var tower: Tower

@onready var equip_menu = $"../EquipMenu"


func _on_backpack_button_pressed():
	SignalMessenger.INVENTORY_TOGGLED.emit(tower, true)


func _on_sell_button_pressed():
	SignalMessenger.INVENTORY_TOGGLED.emit(tower, false)
	SignalMessenger.MONEY_PAYMENT.emit(50)
	tower.queue_free()


func _on_third_button_pressed():
	equip_menu.visible = !equip_menu.visible
