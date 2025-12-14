@tool
extends HBoxContainer
class_name ItemShow

@export var type: ItemStore.ItemType = ItemStore.ItemType.BASEBALL
@export var count: int = 0
@export var autoFree: bool = false
@export var enough: bool = true

@onready var avatarTexture: TextureRect = $"%avatar"
@onready var countLabel: Label = $"%count"
@onready var animator: AnimationPlayer = $"%animator"

func _ready():
	countLabel.label_settings = countLabel.label_settings.duplicate()
	if autoFree:
		animator.play("show")
		await animator.animation_finished
		await TickTool.millseconds(GameRule.itemShowLifetime)
		animator.play("hide")
		await animator.animation_finished
		queue_free()
func _physics_process(_delta):
	avatarTexture.texture = ItemStore.getTexture(type)
	countLabel.text = str(count)
	if enough:
		countLabel.label_settings.font_color = Color.WHITE
	else:
		countLabel.label_settings.font_color = Color.RED

static func generate(itemType: ItemStore.ItemType, itemCount: int = 1, isAutoFree: bool = false):
	var item = ComponentManager.getUIComponent("ItemShow").instantiate()
	item.type = itemType
	item.count = itemCount
	item.autoFree = isAutoFree
	return item
