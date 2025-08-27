extends EntityStateBar
class_name BossBar

@onready var nameLabel: Label = $"%name"
@onready var valueLabel: Label = $"%value"

func _physics_process(delta):
	super._physics_process(delta)
	if is_instance_valid(entity):
		nameLabel.text = entity.displayName
		valueLabel.text = "%.2f" % (entity.health / entity.fields[FieldStore.Entity.MAX_HEALTH] * 100)
