extends CanvasItem
class_name EntityStateBar

@export var entity: EntityBase

@onready var healthBar: ColorBar = $"%health"
@onready var levelLabel: Label = $"%level"
@onready var levelLabels: HBoxContainer = $"%levelLabel"

func forceSync():
	healthBar.maxValue = entity.fields[FieldStore.Entity.MAX_HEALTH]
	healthBar.currentValue = entity.health
	healthBar.forceSync()
