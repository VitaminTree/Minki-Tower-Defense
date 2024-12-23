extends Panel

@export var tower: Tower



func _on_backpack_button_pressed():
	print("Backpack button pressed")


func _on_sell_button_pressed():
	SignalMessenger.MONEY_PAYMENT.emit(50)
	tower.queue_free()


func _on_third_button_pressed():
	print("Third option pressed")
