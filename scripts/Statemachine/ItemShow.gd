@tool
extends HBoxContainer
class_name ItemShow

@export var type: ItemStore.ItemType = ItemStore.ItemType.BASEBALL
@export var count: int = 0

@onready var avatarTexture: TextureRect = $"%avatar"
@onready var countLabel: Label = $"%count"

func _ready():
	avatarTexture.texture = load("res://resources/items/%s.svg" % ItemStore.idMap[type])
	countLabel.text = str(count)
