@tool
extends PanelContainer
class_name TipBox

enum MessageType {
	INFO,
	WARNING,
	ERROR,
	CONGRATULATION,
}

@export var text: String = "nothing"
@export var messageType: MessageType = MessageType.INFO
@export var colorMap = {
	MessageType.INFO: Color.BLACK,
	MessageType.WARNING: Color.BLACK,
	MessageType.ERROR: Color.BLACK,
	MessageType.CONGRATULATION: Color.BLACK,
}

@onready var label: RichTextLabel = $%label
@onready var animator: AnimationPlayer = $%animator

func _ready():
	label.text = text
	animator.play("show")
	var styleBox = get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	styleBox.bg_color = colorMap[messageType]
	add_theme_stylebox_override("panel", styleBox)
func _process(_delta):
	label.text = text

func destroy():
	animator.play("hide")
	await animator.animation_finished
	queue_free()

static func create(applyText: String, applyMessageType: MessageType = MessageType.INFO) -> TipBox:
	var box = ComponentManager.getUIComponent("TipBox").instantiate()
	box.text = applyText
	box.messageType = applyMessageType
	return box
