@tool
extends HBoxContainer
class_name FieldShow

@export var field: FieldStore.Entity = FieldStore.Entity.MAX_HEALTH
@export var value: float = 0
@export var showSign: bool = true

@onready var nameLabel: Label = $"%name"
@onready var valueLabel: Label = $"%value"

func _ready():
	nameLabel.text = FieldStore.entityMap[field]
	var formattedValue: String
	var dataType = FieldStore.entityMapType[field]
	if dataType == FieldStore.DataType.VALUE:
		formattedValue = "%s" % (MathTool.signBeforeStr(value) if showSign else str(value))
	elif dataType == FieldStore.DataType.ANGLE:
		formattedValue = "%s°" % (MathTool.signBeforeStr(value) if showSign else str(value))
	elif dataType == FieldStore.DataType.PERCENT:
		formattedValue = (MathTool.signBeforeStr(value * 100) if showSign else str(value * 100)) + "%"
	valueLabel.text = formattedValue

static func create(newField: FieldStore.Entity, newValue: float, newShowSign: bool) -> FieldShow:
	var fieldShow = preload("res://components/UI/FieldShow.tscn").instantiate()
	fieldShow.field = newField
	fieldShow.value = newValue
	fieldShow.showSign = newShowSign
	return fieldShow
