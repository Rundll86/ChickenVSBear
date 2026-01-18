@tool
extends Weapon

func update(to, origin, _entity):
	origin["atk"] += 1 * to * soulLevel
	origin["count"] = 1 * soulLevel
	origin["split"] /= 1 + 0.005 * to * soulLevel
	return origin
func attack(entity: EntityBase):
	for i in BulletBase.generate(ComponentManager.getBullet("ChainGun"), entity, entity.texture.global_position, (get_global_mouse_position() - entity.texture.global_position).angle()):
		if i is BulletBase:
			i.baseDamage = readStore("atk")
			i.count = floor(readStore("count"))
			i.splits = readStore("split")
	return true
