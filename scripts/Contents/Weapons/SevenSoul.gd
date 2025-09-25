@tool
extends Weapon

func attack(entity: EntityBase):
	for i in 7:
		for j in BulletBase.generate(ComponentManager.getBullet("SevenSoul"), entity, entity.texture.global_position, 0):
			j.index = i
func update(to, origin, _entity):
	origin["atk"] += 1 * to * soulLevel
	return origin
