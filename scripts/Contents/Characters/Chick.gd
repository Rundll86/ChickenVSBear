extends EntityBase
class_name Chick

func _ready():
	fields[FieldStore.Entity.MAX_HEALTH] = 1000
	super._ready()
