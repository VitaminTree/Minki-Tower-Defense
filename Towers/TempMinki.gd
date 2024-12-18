class_name TempMinki extends Tower

var tower = Tower.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	tower.dartDamage = dartDamage
	tower.projectile = projectile
	tower.projectileContainer = projectileContainer
	tower.rangeHitbox = rangeHitbox
	tower.projectileOrigin = projectileOrigin
	tower.timer = timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	tower._process(delta)

func attack(_tgt) -> void:
	pass

func refresh_targets() -> void:
	pass

func target_last(_enemies: Array) -> void:
	pass
