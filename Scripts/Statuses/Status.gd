class_name Status extends Resource

var name: String = "UNSET"
var duration: float = 3.0		# Most effects will dissipate after a certain time limit
var persistent: bool = false	# Some effects have no time limit, lasting until manually removed or the target dies
#var origin: Node = null			# Some effects care about who applied it
var stacks: int = 1				# Some effects may support duplicate instances

func _init(time:float = 3.0):
	duration = time
	
func on_apply(_target: Node) -> void:
	print("Effect applied: ", name)

func refresh(_target: Node) -> void:
	pass

#useful for damage over time
func recurring_effect(_target: Node) -> void:
	pass

func on_remove(_target:Node) -> void:
	print("Effect cleared: ", name)
