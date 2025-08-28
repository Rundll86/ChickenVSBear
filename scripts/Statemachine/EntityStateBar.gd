extends Node
class_name EntityStateBar

@export var entity: EntityBase

@onready var healthBar: ColorBar = $"%health"
@onready var levelLabel: Label = $"%level"
