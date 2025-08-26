extends Node2D

@export var entity: EntityBase

@onready var healthBar: ColorBar = $"%health"

func _process(_delta):
	if entity:
		healthBar.maxValue = entity.maxHealth
		healthBar.setCurrent(entity.health)
