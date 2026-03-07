@tool
extends Weapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["atk"] += 2 * to * soulLevel
	origin["speed"] += 0.004 * to * soulLevel
	return origin
func attack(entity: EntityBase):
	attackSpeed = 1 + readStore("speed")
	for bullet in BulletBase.generate(
		ComponentManager.getBullet("CursorKnife"),
		entity,
		get_global_mouse_position(),
		entity.position.angle_to_point(get_global_mouse_position())
	):
		if bullet is CursorKnifeBullet:
			bullet.baseDamage = readStore("atk")
	return true
