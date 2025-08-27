@tool
extends HBoxContainer
class_name ItemShow

@export var type: ItemStore.ItemType = ItemStore.ItemType.BASEBALL
@export var count: int = 0

@onready var avatarTexture: TextureRect = $"%avatar"
@onready var countLabel: Label = $"%count"

func _physics_process(_delta):
	avatarTexture.texture = ItemStore.getTexture(type)
	countLabel.text = str(count)

static func generate(itemType: ItemStore.ItemType, itemCount: int = 1):
	var item = preload("res://components/UI/ItemShow.tscn").instantiate()
	item.type = itemType
	item.count = itemCount
	return item
