extends Node2D
class_name DamageLabel

@export var damage: float = 0
@export var crit: bool = false

@onready var label: Label = $"%label"
@onready var animator: AnimationPlayer = $"%animator"

func _ready():
	if damage == 0:
		label.text = "MISS"
	else:
		label.text = str(round(damage)) + ("!!!" if crit else "")
	animator.play("show")
	await animator.animation_finished
	queue_free()

static func create(spawnDamage: float, spawnCrit: bool, spawnPosition: Vector2, addToWorld: bool = true) -> DamageLabel:
	var instance = preload("res://components/UI/DamageLabel.tscn").instantiate()
	instance.damage = spawnDamage
	instance.crit = spawnCrit
	instance.position = spawnPosition
	if addToWorld:
		WorldManager.rootNode.add_child(instance)
	return instance
