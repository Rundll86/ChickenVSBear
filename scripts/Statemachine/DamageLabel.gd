extends Node2D
class_name DamageLabel

@export var damage: float = 0
@export var crit: bool = false
func _ready():
	$"%label".text = str(round(damage)) + ("!!!" if crit else "")
	$"%animator".play("show")
	await $"%animator".animation_finished

static func create(spawnDamage: float, spawnCrit: bool, spawnPosition: Vector2, addToWorld: bool = true) -> DamageLabel:
	var instance = preload("res://components/UI/DamageLabel.tscn").instantiate()
	instance.damage = spawnDamage
	instance.crit = spawnCrit
	instance.position = spawnPosition
	if addToWorld:
		WorldTool.rootNode.add_child(instance)
	return instance
