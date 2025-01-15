class_name BananaPeel extends Tower

# Copy-Paste from the Bomb tower.
# Ideally, the banana would persist for a number of attacks, and only attack each enemy once
# Likely need to bypass the search for enemy function, and only attack when an enemy body
# enters the attack area.
# for now, a disposable effect will do.

@onready var sprite_2d = $Sprite2D
@onready var bullet_range_visual = $BulletRangeVisual
@onready var outline_shader = $OutlineShader
@onready var tower_menu = $TowerMenu


var shot: bool = false

func _process(_delta: float) -> void:
	var timer_stopped: bool = timer.is_stopped()
	if shot and timer_stopped:
		GameData.remove_tower(data)
		queue_free()
	if not timer_stopped:
		shot = true
		disappear()
	super._process(_delta)

func attack(tgt: Node2D, atk: PackedScene, origin: Marker2D) -> void:
	if not shot:
		super.attack(tgt, atk, origin)

func disappear() -> void:
	hovering = false
	selected = false
	sprite_2d.visible = false
	bullet_range_visual.visible = false
	outline_shader.visible = false
	tower_menu.visible = false
