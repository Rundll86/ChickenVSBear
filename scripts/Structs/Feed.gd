@tool
extends PanelContainer
class_name Feed

signal selected(applied: bool)

@export var avatarTexture: Texture2D = preload("res://icon.svg")
@export var displayName: String = "未命名饲料"
@export var quality: FeedName.Quality = FeedName.Quality.COMMON
@export var fields: Array[FieldStore.Entity] = []
@export var fieldValues: Array[float] = []
@export var costs: Array[ItemStore.ItemType] = []
@export var costCounts: Array[int] = []

@onready var avatarRect: TextureRect = $"%avatar"
@onready var nameLabel: FeedName = $"%name"
@onready var fieldsBox: VBoxContainer = $"%fields"
@onready var costsBox: GridContainer = $"%costs"
@onready var selectButton: Button = $"%selectBtn"

func _ready():
	selectButton.pressed.connect(
		func():
			apply(UIState.player)
	)
	avatarRect.texture = avatarTexture
	nameLabel.displayName = displayName
	nameLabel.quality = quality
	for i in fieldsBox.get_children():
		i.queue_free()
	var noField = true
	for i in range(min(fields.size(), fieldValues.size())):
		noField = false
		var field = fields[i]
		var value = fieldValues[i]
		var fieldShow: FieldShow = preload("res://components/UI/FieldShow.tscn").instantiate()
		fieldShow.field = field
		fieldShow.value = value
		fieldsBox.add_child(fieldShow)
	if noField:
		fieldsBox.add_child(QuickUI.smallText("无词条"))
	for i in costsBox.get_children():
		i.queue_free()
	for i in range(min(costs.size(), costCounts.size())):
		var cost = costs[i]
		var count = costCounts[i]
		var costShow: ItemShow = preload("res://components/UI/ItemShow.tscn").instantiate()
		costShow.type = cost
		costShow.count = int(count * multipiler())
		costsBox.add_child(costShow)

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
		for i in range(min(fields.size(), fieldValues.size())):
			var field = fields[i]
			var value = fieldValues[i]
			var applier = FieldStore.entityApplier.get(field, null)
			if !applier or applier.call(entity, value):
				entity.fields[field] += value
		hide()
	selected.emit(allHave)
	return allHave
func multipiler() -> float:
	if is_instance_valid(UIState.player):
		return 1 - UIState.player.fields.get(FieldStore.Entity.PRICE_REDUCTION)
	else:
		return 1
