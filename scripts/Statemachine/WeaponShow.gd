@tool
extends HBoxContainer
class_name WeaponShow

enum Operation {
	GET,
	EXTRACT,
}

@export var weapon: PackedScene = null
@export var operation: Operation = Operation.GET

@onready var operationLabel: Label = $"%operation"
@onready var avatarRect: TextureRect = $"%avatar"
@onready var nameLabel: Label = $"%name"
@onready var soulShow: ItemShow = $"%soul"

func _ready():
	var weaponInstance = weapon.instantiate() as Weapon
	avatarRect.texture = weaponInstance.avatarTexture
	nameLabel.text = weaponInstance.displayName
	soulShow.count = weaponInstance.soulLevel
	if operation == Operation.GET:
		operationLabel.text = "获得武器"
		avatarRect.visible = true
		nameLabel.visible = true
		soulShow.visible = false
	else:
		operationLabel.text = "提炼灵魂"
		avatarRect.visible = false
		nameLabel.visible = false
		soulShow.visible = true
