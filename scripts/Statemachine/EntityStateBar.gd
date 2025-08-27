extends Node
class_name EntityStateBar

@export var entity: EntityBase

@onready var healthBar: ColorBar = $"%health"

func _ready():
	if is_instance_valid(entity):
		entity.healthChanged.connect(
			func(health) -> void:
				healthBar.maxValue = entity.fields.get(FieldStore.Entity.MAX_HEALTH)
				healthBar.setCurrent(health)
		)
