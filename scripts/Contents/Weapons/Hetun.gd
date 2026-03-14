@tool
extends Weapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["atk"] += 3 * to * soulLevel
	origin["count"] += 5 * (soulLevel - 1)
	origin["penerate"] += 0.1 * (soulLevel - 1)
	return origin
func attack(entity: EntityBase):
	for i in readStore("count"):
		for bullet in BulletBase.generate(
			ComponentManager.getBullet("Needle"),
			entity,
			entity.findWeaponAnchor("normal"),
			entity.findWeaponAnchor("normal").angle_to_point(get_global_mouse_position()) + deg_to_rad(randf_range(-1, 1) * 30)
		):
			if bullet is NeedleBullet:
				bullet.baseDamage = readStore("atk")
				bullet.penerate = readStore("penerate")
	return true
