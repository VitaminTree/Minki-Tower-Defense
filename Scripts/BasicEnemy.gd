class_name enemy extends CharacterBody2D

@onready var progress_bar: TextureProgressBar = $ProgressBar

# I want the health of an enemy type to be editable via the Inspector, so an @export is needed
# I also want the health bar to be modified via the setter, so that it doesnt check for an update every cycle
# However, if the health is modified via the Inspector, then the setter is called while being instantiated
# 	before the health bar exists, resulting in an error.
# SOLUTION: Another variable "healthpoints" is created as a variable to be exported.
# 	The enemy has no health when being created, but is assigned the value of healthpoints when entering the scene
#	via the _ready() function
var health: float:
	get:
		return health
	set(value): 
		health = value
		progress_bar.value = value
		if health <= 0:
			SignalMessenger.MONEY_PAYMENT.emit(payment)
			SignalMessenger.ENEMY_LEFT.emit()
			get_parent().queue_free()
			return
		if health < progress_bar.max_value:
			progress_bar.visible = true

var statusEffects: Array = []

@export var healthpoints: int = 1
@export var speed = 200
@export var damage = 1
@export var payment = 5



func _ready() -> void:
	health = healthpoints
	progress_bar.max_value = health
	progress_bar.visible = false

func _process(delta: float) -> void:
	var path = get_parent()
	path.set_progress(path.get_progress()+speed*delta)
	if path.get_progress_ratio() == 1:
		SignalMessenger.HEALTH_UPDATE.emit(-1*damage)
		SignalMessenger.ENEMY_LEFT.emit()
		get_parent().queue_free()
	
	# Tick down the duration of evey current effect, unless it's persistent
	for i in range(statusEffects.size()):
		var effect = statusEffects[i]
		if not effect.persistent:
			effect.duration -= delta
	
	# Remove effects that have reached the end of their lifetime.
	# Note: Only 1 effect can be removed per cycle. May be worth visiting if granularity is needed
	for j in range(statusEffects.size()):
		var effect = statusEffects[j]
		if effect.duration < 0:
			effect.on_remove(self)
			statusEffects.remove_at(j)
			reapply_status()
			break

func apply_status(effect: Status) -> void:
	for i in range(statusEffects.size()):
		if statusEffects[i].name == effect.name:
			statusEffects[i].duration = effect.duration
			return

	statusEffects.append(effect)
	effect.on_apply(self)

func reapply_status() -> void:
	for i in statusEffects:
		apply_status(i)

