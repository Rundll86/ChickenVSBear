class_name PresetEntityAI

static func follow(entity: EntityBase, target: EntityBase, minDistance: float = 100):
	var delta = target.position - entity.position
	var distanceOffset = abs(delta.length() - minDistance)
	if distanceOffset > entity.fields[FieldStore.Entity.MOVEMENT_SPEED] * 10:
		if delta.length() < minDistance:
			entity.move(-delta)
		else:
			entity.move(delta)
