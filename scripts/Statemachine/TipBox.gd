@tool
extends PanelContainer
class_name TipBox

@export var text: String = "nothing"

@onready var label: Label = $%label
@onready var animator: AnimationPlayer = $%animator

func _ready():
    label.text = text
    animator.play("show")
func _process(_delta):
    label.text = text

func destroy():
    animator.play("hide")
    await animator.animation_finished
    queue_free()

static func create(applyText: String) -> TipBox:
    var box = ComponentManager.getUIComponent("TipBox")
    box.text = applyText
    return box
