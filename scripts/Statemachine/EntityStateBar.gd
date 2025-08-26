extends Node
class_name EntityStateBar

@export var entity: EntityBase

@onready var healthBar: ColorBar = $"%health"

func _process(_delta):
	if is_instance_valid(entity):
		healthBar.maxValue = entity.fields.get(FieldStore.Entity.MAX_HEALTH)
		healthBar.setCurrent(entity.health)
