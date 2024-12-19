class_name IceMinki extends Tower

var tower = Tower.new()

# Called when the node enters the scene tree for the first time.
func _ready():
#	tower.projectile = projectile
#	tower.rangeHitbox = rangeHitbox
#	tower.projectileOrigin = projectileOrigin
#	tower.timer = timer
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	target = tower.refresh_targets(rangeHitbox)
	if timer.is_stopped():
		tower.attack(target, projectile, projectileOrigin)
		timer.start()

func attack(_tgt: Node2D, _atk: PackedScene, _origin: Marker2D) -> void:
	pass

func refresh_targets(_area: Area2D) -> Node2D:
	return

func target_last(_enemies: Array) -> Node2D:
	return
