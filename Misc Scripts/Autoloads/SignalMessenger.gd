extends Node

# The recieving Node has to connect the signal to a function using the following:
#			"SignalMessenger.connect("NAME_OF_SIGNAL_IN_QUOTES", function_name_without_quotes)
# This doesnt change even if the function takes parameters 
#
# the sending Node does not need to connect; it just emits
#			"SignalMessenger.NAME_OF_SIGNAL.emit()"
 
signal HELLO_WORLD
signal SIGNAL_WITH(arguments)

# Modifies the current value of the resource by a given amount.
# if amount is positive, the current value of th eresource goes up that that amount
# negative numbers will reduce the current value by that amount
signal MONEY_PAYMENT(amount: int)
signal HEALTH_UPDATE(amount: int)
signal SPIRIT_PAYMENT(amount:int)

# These signals carry the value of th eresource at the time of emitting.
# Generally used by nodes that need to know the current value
signal BALANCE_UPDATED(amount: int)
signal SPIRIT_UPDATED(amount: int)
signal ALL_LIVES_LOST

signal MOUSE_OVER_PATH(state: bool)
signal MOUSE_OVER_WATER(state: bool)

# Unused
signal STATUS_APPLIED

# Used to "drop" the held item if the inventory is hidden while holding something
signal INVENTORY_TOGGLED
# signal ITEM_CLICKED(index: int) [RELOCATED TO SlotPanel]
signal INVENTORY_PROCESSED(inventory_data: Inventory, index: int, button: int)
signal INVENTORY_UPDATED(inventory_data: Inventory, inventory_type: int)

signal TOWER_UPGRADED(item: ItemData, index: int)
signal TOWER_UPGRADE_INTERACTED(inventory_data: Inventory, index: int)
signal TOWER_DOWNGRADED(index: int)

# When a tower is clicked, emit this signal
# PlayerInventory will connect and determine if the currently held item can be upgraded 
signal TOWER_UPGRADE_QUERY(inventory_data: Inventory, tags: Array[Tag])

signal ENEMY_LEFT
signal WAVE_OVER

signal SHOP_READY
signal SHOP_SUMMONED #Only used by the shop summon button atm, may become redundant if Spirit is moved to an autoload
signal SHOP_ITEM_CLICKED(index: int)
signal SHOP_DISCARD_INTERACTED(inventory_data: Inventory)

signal PAUSE_CLICKED

# Tower Panel is the one the player clicks to put a new tower onto the map
signal TOWER_PANEL_CLICK_PRESSED(index: int)
signal TOWER_PANEL_CLICK_RELEASED(index: int, mouse_held: bool)
