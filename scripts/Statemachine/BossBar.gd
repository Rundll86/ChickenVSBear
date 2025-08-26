extends EntityStateBar
class_name BossBar

@onready var nameLabel: Label = $"%name"
@onready var valueLabel: Label = $"%value"

func _process(delta):
	super._process(delta)
	if entity:
		nameLabel.text = entity.displayName
		valueLabel.text = "%.2f" % (entity.health / entity.fields[FieldStore.Entity.MAX_HEALTH] * 100)
