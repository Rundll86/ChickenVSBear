@tool
extends HBoxContainer
class_name FieldShow

@export var field: FieldStore.Entity = FieldStore.Entity.MAX_HEALTH
@export var value: float = 0

@onready var nameLabel: Label = $"%name"
@onready var valueLabel: Label = $"%value"

func _ready():
	nameLabel.text = FieldStore.entityMap[field]
	var formattedValue: String
	var dataType = FieldStore.entityMapType[field]
	if dataType == FieldStore.DataType.VALUE:
		formattedValue = MathTool.signBeforeStr(value)
	elif dataType == FieldStore.DataType.ANGLE:
		formattedValue = MathTool.signBeforeStr(value) + "°"
	elif dataType == FieldStore.DataType.PERCENT:
		formattedValue = MathTool.signBeforeStr(float("%.1f" % (value * 100))) + "%"
	valueLabel.text = formattedValue
