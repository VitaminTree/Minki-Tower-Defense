extends CanvasLayer

@onready var label = $CurrentLevelLabel
@onready var image = $MapPreviewImage

const maps = {
	"One" : "res://Assets/Track.png",
	"Two" : "res://Assets/river.png"
}

func _ready() -> void:
	label.text = "Current level: " + GameData.LevelName
	if GameData.LevelName != "":
		var n = GameData.LevelName
		var temp = load(maps[n])
		image.texture = temp
