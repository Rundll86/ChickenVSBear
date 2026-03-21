@tool
extends Weapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["atk"] += 5 * to * soulLevel
	origin["count"] += 1 * (soulLevel - 1)
	origin["max"] += 2 * (soulLevel - 1)
	return origin
func attack(entity: EntityBase):
	for bullet in BulletBase.generate(
		ComponentManager.getBullet("Parrier"),
		entity,
		entity.texture.global_position,
		entity.texture.global_position.angle_to_point(get_global_mouse_position()),
	):
		if bullet is ParrierBullet:
			bullet.atk = readStore("atk")
			bullet.maxParryTimes = readStore("count")
			bullet.maxBallCount = readStore("max")
	return true
