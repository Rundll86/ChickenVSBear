extends Node2D
class_name DamageLabel

@export var damage: float = 0
@export var crit: bool = false
@export var color1: Color = Color(1, 0, 0, 1)
@export var color2: Color = Color(0, 1, 0, 1)
@export var color3: Color = Color(0.5, 0.5, 0.5, 1)
@export var color4: Color = Color.YELLOW

@onready var label: Label = $"%label"
@onready var animator: AnimationPlayer = $"%animator"

func _ready():
	label.label_settings = label.label_settings.duplicate()
	var damageValue = round(abs(damage))
	var damageSign = sign(damage)
	if damageSign > 0:
		label.label_settings.font_color = color1
		label.text = "%s%s" % [damageValue, "!!!" if crit else ""]
	elif damageSign < 0:
		label.label_settings.font_color = color2
		label.text = "+%s%s" % [damageValue, "!!!" if crit else ""]
	else:
		if crit:
			label.label_settings.font_color = color4
			label.text = "完美闪避"
		else:
			label.label_settings.font_color = color3
			label.text = "闪避"
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
