@tool
extends Weapon

func attack(entity: EntityBase):
	playSound("attack")
	for i in 6:
		for j in BulletBase.generate(ComponentManager.getBullet("SevenSoul"), entity, entity.texture.global_position, 0):
			j.index = i
		await TickTool.millseconds(20000 / 6.0)
func update(to, origin, _entity):
	origin["atk"] += 1 * to * soulLevel
	return origin
