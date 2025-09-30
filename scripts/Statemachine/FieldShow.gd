@tool
extends HBoxContainer
class_name FieldShow

@export var field: FieldStore.Entity = FieldStore.Entity.MAX_HEALTH
@export var value: float = 0
@export var showSign: bool = true
@export var entity: EntityBase = null
@export var useViewCast: bool = false
@export var maxed: bool = false
@export var showAdvantage: bool = false

@onready var nameLabel: Label = $"%name"
@onready var valueLabel: Label = $"%value"

func _ready():
	if useViewCast:
		var caster = FieldStore.entityViewCastMap.get(field)
		if caster:
			value = caster.call(entity, value)
	nameLabel.text = FieldStore.entityMap[field]
	var formattedValue: String
	var dataType = FieldStore.entityMapType[field]
	if dataType == FieldStore.DataType.VALUE:
		formattedValue = "%s" % (MathTool.signBeforeStr(value) if showSign else str(value))
	elif dataType == FieldStore.DataType.INTEGER:
		formattedValue = "%s" % (MathTool.signBeforeStr(int(value)) if showSign else str(int(value)))
	elif dataType == FieldStore.DataType.ANGLE:
		formattedValue = "%s°" % (MathTool.signBeforeStr(value) if showSign else str(value))
	elif dataType == FieldStore.DataType.PERCENT:
		formattedValue = (MathTool.signBeforeStr(value * 100) if showSign else str(value * 100)) + "%"
	valueLabel.label_settings = valueLabel.label_settings.duplicate()
	valueLabel.text = formattedValue
	if maxed:
		valueLabel.label_settings.font_color = Color(1, 0.3, 0.3)
		valueLabel.text = "MAX%s" % valueLabel.text
	elif showAdvantage:
		if field in FieldStore.entityNegativeFields:
			valueLabel.label_settings.font_color = Color.RED if value > 0 else Color.GREEN
		else:
			valueLabel.label_settings.font_color = Color.GREEN if value > 0 else Color.RED
	else:
		valueLabel.label_settings.font_color = Color(1, 1, 1)

static func create(newField: FieldStore.Entity, newValue: float, newShowSign: bool, newEntity: EntityBase, newUseViewCast: bool) -> FieldShow:
	var fieldShow = ComponentManager.getUIComponent("FieldShow").instantiate()
	fieldShow.field = newField
	fieldShow.value = newValue
	fieldShow.showSign = newShowSign
	fieldShow.entity = newEntity
	fieldShow.useViewCast = newUseViewCast
	return fieldShow
