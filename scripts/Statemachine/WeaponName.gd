@tool
extends HBoxContainer
class_name WeaponName

enum Quality {
	WASTE,
	COMMON,
	RARE,
	EPIC,
	LEGENDARY,
}
enum TypeTopic {
	IMPACT,
	ENERGY,
	TEMPERATURE,
	MAGIC,
}

@export var displayName: String = "未命名武器"
@export var quality: Quality = Quality.COMMON
@export var typeTopic: TypeTopic = TypeTopic.IMPACT
@export var level: int = 0
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
	Quality.WASTE: 20,
	Quality.COMMON: 100,
	Quality.RARE: 30,
	Quality.EPIC: 10,
	Quality.LEGENDARY: 5
}
@export var luckInfluence = {
	Quality.WASTE: - 0.5,
	Quality.COMMON: - 1,
	Quality.RARE: 0,
	Quality.EPIC: 1,
	Quality.LEGENDARY: 2,
}
@export var typeTopicNameMap = {
	TypeTopic.IMPACT: "冲击",
	TypeTopic.ENERGY: "能量",
	TypeTopic.TEMPERATURE: "熔融",
	TypeTopic.MAGIC: "魔法",
}
@export var typeTopicColorMap = {
	TypeTopic.IMPACT: Color(),
	TypeTopic.ENERGY: Color(),
	TypeTopic.TEMPERATURE: Color(),
	TypeTopic.MAGIC: Color(),
}

@onready var qualityLabel: Label = $"%quality"
@onready var typeTopicLabel: Label = $"%typeTopic"
@onready var nameLabel: RichTextLabel = $"%label"
@onready var levelLabel: RichTextLabel = $"%level"

func _ready():
	qualityLabel.label_settings = qualityLabel.label_settings.duplicate()
	typeTopicLabel.label_settings = typeTopicLabel.label_settings.duplicate()
func _physics_process(_delta):
	qualityLabel.text = "[%s]" % qualityNameMap[quality]
	qualityLabel.label_settings.font_color = qualityColor()
	typeTopicLabel.text = "[%s]" % typeTopicNameMap[typeTopic]
	typeTopicLabel.label_settings.font_color = typeTopicColor()
	nameLabel.text = "[b]%s[/b]" % displayName
	levelLabel.text = "[b]Lv.%d[/b]" % (level + 1)
func qualityColor():
	return qualityColorMap[quality] as Color
func typeTopicColor():
	return typeTopicColorMap[typeTopic] as Color
func weight(player: EntityBase) -> int:
	return floor(clamp(qualityRandomWeight[quality] + luckInfluence[quality] * player.fields[FieldStore.Entity.LUCK_VALUE], 1, INF))
