extends TextureProgressBar

func _ready() -> void:
	max_value = get_parent().health
	visible = false

func _process(_delta: float) -> void:
	value = get_parent().health
	if value < max_value:
		visible = true
