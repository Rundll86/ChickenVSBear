@tool
extends HBoxContainer

@export var field: FieldStore.Entity = FieldStore.Entity.MAX_HEALTH
@export var value: String = ""

@onready var nameLabel: Label = $"%name"
@onready var valueLabel: Label = $"%value"

func _process(_delta):
	nameLabel.text = FieldStore.entityMap[field]
	valueLabel.text = value
