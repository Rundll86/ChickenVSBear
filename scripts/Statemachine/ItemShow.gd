@tool
extends HBoxContainer

@export var type: ItemStore.ItemType = ItemStore.ItemType.BASEBALL
@export var count: int = 0

@onready var avatarTexture: TextureRect = $"%avatar"
@onready var countLabel: Label = $"%count"

func _process(_delta):
	avatarTexture.texture = load("res://resources/items/%s.svg" % ItemStore.idMap[type])
	countLabel.text = str(count)
