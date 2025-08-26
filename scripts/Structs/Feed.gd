@tool
extends PanelContainer
class_name Feed

@export var avatarTexture: Texture2D = null
@export var displayName: String = "未命名饲料"
@export var fields: Array[FieldStore.Entity] = []
@export var fieldValues: Array[float] = []
@export var costs: Array[ItemStore.ItemType] = []
@export var costCounts: Array[int] = []

@onready var avatarRect: TextureRect = $"%avatar"
@onready var nameLabel: Label = $"%name"
@onready var fieldsBox: VBoxContainer = $"%fields"
@onready var costsBox: GridContainer = $"%costs"

func _ready():
	avatarRect.texture = avatarTexture
	nameLabel.text = displayName
	for i in fieldsBox.get_children():
		i.queue_free()
	for i in range(min(fields.size(), fieldValues.size())):
		var field = fields[i]
		var value = fieldValues[i]
		var fieldShow: FieldShow = preload("res://components/UI/FieldShow.tscn").instantiate()
		fieldShow.field = field
		fieldShow.value = str(value)
		fieldsBox.add_child(fieldShow)
	for i in costsBox.get_children():
		i.queue_free()
	for i in range(min(costs.size(), costCounts.size())):
		var cost = costs[i]
		var count = costCounts[i]
		var costShow: ItemShow = preload("res://components/UI/ItemShow.tscn").instantiate()
		costShow.type = cost
		costShow.count = count
		costsBox.add_child(costShow)
