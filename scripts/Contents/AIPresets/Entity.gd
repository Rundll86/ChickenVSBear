class_name PresetEntityAI

static func follow(entity: EntityBase, target: EntityBase, minDistance: float = 100):
	var delta = target.position - entity.position
	var distanceOffset = abs(delta.length() - minDistance)
	if distanceOffset > entity.fields[FieldStore.Entity.MOVEMENT_SPEED] * 10:
		if delta.length() < minDistance:
			entity.move(-delta)
		else:
			entity.move(delta)
static func distanceAttack(entity: EntityBase, target: EntityBase, minDistance: float, maxDistance: float, index: int = 0):
	var distance = (entity.position - target.position).length()
	if minDistance <= distance and distance <= maxDistance:
		entity.tryAttack(index)
static func distanceAction(entity: EntityBase, target: EntityBase, minDistance: float, maxDistance: float, action: Callable):
	var distance = (entity.position - target.position).length()
	if minDistance <= distance and distance <= maxDistance:
		action.call()
static func weightAttack(entity: EntityBase, indexes: Array[int], weight: Array[int], chargeUp: Callable):
	var method = MathTool.randChoiceWeightsFrom(indexes, weight)
	entity.tryAttack(method, chargeUp.call(method))
