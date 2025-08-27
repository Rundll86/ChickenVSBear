extends EntityStateBar
class_name BossBar

@onready var nameLabel: Label = $"%name"
@onready var valueLabel: Label = $"%value"

func _ready():
	if is_instance_valid(entity):
		nameLabel.text = entity.displayName
func _process(_delta):
	if is_instance_valid(entity):
		valueLabel.text = "%.2f" % (entity.health / entity.fields[FieldStore.Entity.MAX_HEALTH] * 100)
