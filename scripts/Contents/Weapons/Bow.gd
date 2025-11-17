@tool
extends Weapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["atk"] += 0.05 * to * soulLevel
	origin["count"] = 1 * soulLevel
	origin["self"] += 0.05 * to
	return origin
func attack(entity: EntityBase):
	entity.takeDamage(readStore("self"))
	var weaponPos = entity.findWeaponAnchor("normal")
	for i in BulletBase.generate(
			ComponentManager.getBullet("Bow"),
			entity,
			weaponPos,
			weaponPos.angle_to_point(get_global_mouse_position())
		):
			var bullet: Bow = i
			bullet.count = readStore("count")
			bullet.atk = readStore("atk")
