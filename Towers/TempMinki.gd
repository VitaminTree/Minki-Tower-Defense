class_name TempMinki extends Tower

var tower = Tower.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	tower.projectile = projectile
	tower.rangeHitbox = rangeHitbox
	tower.projectileOrigin = projectileOrigin
	tower.timer = timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	tower._process(delta)

func attack(_tgt: Node2D, _atk: PackedScene, _origin: Marker2D) -> void:
	pass

func refresh_targets(_area: Area2D) -> Node2D:
	return

func target_last(_enemies: Array) -> Node2D:
	return
