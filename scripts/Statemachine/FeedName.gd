@tool
extends HBoxContainer
class_name FeedName

enum Quality {
	WASTE,
	COMMON,
	RARE,
	EPIC,
	LEGENDARY,
}

@export var displayName: String = "未命名饲料"
@export var quality: Quality = Quality.COMMON
@export var qualityColorMap = {
	Quality.WASTE: Color(),
	Quality.COMMON: Color(),
	Quality.RARE: Color(),
	Quality.EPIC: Color(),
	Quality.LEGENDARY: Color()
}
@export var qualityNameMap = {
	Quality.WASTE: "常见",
	Quality.COMMON: "普通",
	Quality.RARE: "稀有",
	Quality.EPIC: "史诗",
	Quality.LEGENDARY: "传说"
}
@export var qualityRandomWeight = {
	Quality.WASTE: 5,
	Quality.COMMON: 50,
	Quality.RARE: 10,
	Quality.EPIC: 5,
	Quality.LEGENDARY: 1
}

@onready var qualityLabel: Label = $"%quality"
@onready var nameLabel: RichTextLabel = $"%label"

func _ready():
	qualityLabel.label_settings = qualityLabel.label_settings.duplicate()
func _physics_process(_delta):
	qualityLabel.text = "[%s]" % qualityNameMap[quality]
	qualityLabel.label_settings.font_color = color()
	nameLabel.text = "[b]%s[/b]" % displayName
func color():
	return qualityColorMap[quality] as Color
