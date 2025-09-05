@tool
extends PanelContainer
class_name Weapon

signal selected(applied: bool)

@export var avatarTexture: Texture2D = preload("res://icon.svg")
@export var displayName: String = "未命名饲料"
@export var quality: WeaponName.Quality = WeaponName.Quality.COMMON
@export var typeTopic: WeaponName.TypeTopic = WeaponName.TypeTopic.IMPACT
@export var costs: Array[ItemStore.ItemType] = []
@export var costCounts: Array[int] = []
@export var store: Dictionary = {
	"atk": 10
}
@export var descriptionTemplate: String = "造成$atk点伤害。"
@export var needEnergy: float = 0
@export var cooldown: float = 100

@onready var avatarRect: TextureRect = $"%avatar"
@onready var nameLabel: WeaponName = $"%name"
@onready var energyLabel: Label = $"%energy"
@onready var descriptionLabel: RichTextLabel = $"%description"
@onready var costsBox: GridContainer = $"%costs"
@onready var selectButton: Button = $"%selectBtn"

var cooldownTimer = CooldownTimer.new()

func _ready():
	selectButton.pressed.connect(
		func():
			apply(UIState.player)
	)
	cooldownTimer.cooldown = cooldown
	rebuildInfo()
func _physics_process(_delta: float):
	descriptionLabel.text = buildDescription()

func allHad(entity: EntityBase) -> bool:
	var allHave = true
	for i in range(min(costs.size(), costCounts.size())):
		var item = costs[i]
		var count = costCounts[i] * multipiler()
		if entity.inventory[item] < count:
			allHave = false
			break
	return allHave
func apply(entity: EntityBase):
	var allHave = allHad(entity)
	if allHave:
		for i in range(min(costs.size(), costCounts.size())):
			var item = costs[i]
			var count = costCounts[i] * multipiler()
			entity.inventory[item] -= count
		hide()
	selected.emit(allHave)
	return allHave
func multipiler() -> float:
	if is_instance_valid(UIState.player):
		return 1 - UIState.player.fields.get(FieldStore.Entity.PRICE_REDUCTION)
	else:
		return 1
func rebuildInfo():
	avatarRect.texture = avatarTexture
	nameLabel.displayName = displayName
	nameLabel.quality = quality
	nameLabel.typeTopic = typeTopic
	energyLabel.text = "%.1f" % needEnergy
	for i in costsBox.get_children():
		i.queue_free()
	for i in range(min(costs.size(), costCounts.size())):
		var cost = costs[i]
		var count = costCounts[i]
		var costShow: ItemShow = preload("res://components/UI/ItemShow.tscn").instantiate()
		costShow.type = cost
		costShow.count = int(count * multipiler())
		costsBox.add_child(costShow)
func buildDescription():
	var result = descriptionTemplate
	for key in store.keys():
		result = result.replace("$" + key, "[color=cyan]%.1f[/color]" % readStore(key))
	return "[center]%s[/center]" % result
func readStore(key: String, default: Variant = null):
	return store.get(key, default)

# 抽象
func update(_to: int, _origin: Dictionary, _entity: EntityBase):
	pass
func attack(_entity: EntityBase):
	pass
