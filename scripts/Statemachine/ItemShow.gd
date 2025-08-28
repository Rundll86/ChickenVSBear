@tool
extends HBoxContainer
class_name ItemShow

@export var type: ItemStore.ItemType = ItemStore.ItemType.BASEBALL
@export var count: int = 0
@export var autoFree: bool = false

@onready var avatarTexture: TextureRect = $"%avatar"
@onready var countLabel: Label = $"%count"
@onready var animator: AnimationPlayer = $"%animator"

func _ready():
	if autoFree:
		animator.play("show")
		await animator.animation_finished
		await TickTool.millseconds(GameRule.itemShowLifetime) # 等待几秒后自动隐藏
		animator.play("hide")
		await animator.animation_finished
		queue_free()
func _physics_process(_delta):
	avatarTexture.texture = ItemStore.getTexture(type)
	countLabel.text = str(count)

static func generate(itemType: ItemStore.ItemType, itemCount: int = 1, isAutoFree: bool = false):
	var item = preload("res://components/UI/ItemShow.tscn").instantiate()
	item.type = itemType
	item.count = itemCount
	item.autoFree = isAutoFree
	return item
