extends Node

# The recieving Node has to connect the signal to a function using the following:
#			"SignalMessenger.connect("NAME_OF_SIGNAL_IN_QUOTES", function_name_without_quotes)
# This doesnt change even if the function takes parameters 
#
# the sending Node does not need to connect; it just emits
#			"SignalMessenger.NAME_OF_SIGNAL.emit()"
 
signal HELLO_WORLD
signal SIGNAL_WITH(arguments)

signal MONEY_PAYMENT(amount: int)
signal HEALTH_UPDATE(amount: int)
signal SPIRIT_PAYMENT(amount:int)

signal BALANCE_UPDATED(amount: int)
signal SPIRIT_UPDATED(amount: int)
signal ALL_LIVES_LOST

signal MOUSE_OVER_PATH(state: bool)
signal MOUSE_OVER_WATER(state: bool)

signal STATUS_APPLIED

signal INVENTORY_TOGGLED(tower: Tower, make_visible: bool)
# signal ITEM_CLICKED(index: int) [RELOCATED TO SlotPanel]
signal INVENTORY_PROCESSED(inventory_data: Inventory, index: int)
signal INVENTORY_UPDATED(inventory_data: Inventory)

signal TOWER_UPGRADED

signal ENEMY_LEFT

signal SHOP_READY
signal SHOP_SUMMONED #Only used by the shop summon button atm, may become redundant if Spirit is moved to an autoload
