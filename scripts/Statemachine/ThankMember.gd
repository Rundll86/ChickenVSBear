@tool
extends VBoxContainer

@export var memberName: String = "未命名成员"
@export var memberAvatar: Texture2D = null
@export var memberDescription: String = "未知描述"

@onready var avatar: Circle = $"%avatar"
@onready var nameLabel: Label = $"%name"
@onready var descriptionLabel: Label = $"%description"

func _process(_delta):
	nameLabel.text = memberName
	descriptionLabel.text = memberDescription
	avatar.avatar = memberAvatar
