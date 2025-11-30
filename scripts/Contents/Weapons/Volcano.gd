@tool
extends Weapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["rotate"] += 0.005 * to * soulLevel
	origin["dmg1"] += 0.01 * to * soulLevel
	origin["dmg2"] += 0.01 * to * soulLevel
	origin["dmg3"] += 0.01 * to * soulLevel
	origin["dmg4"] += 0.01 * to * soulLevel
	origin["dmg5"] += 0.01 * to * soulLevel
	origin["count"] = 1 * soulLevel
	origin["atk"] += 1 * to * soulLevel
	return origin
func attack(entity: EntityBase):
	for j in BulletBase.generate(
		ComponentManager.getBullet("Volcano"),
		entity,
		entity.findWeaponAnchor("normal"),
		entity.position.angle_to_point(entity.get_global_mouse_position()), false, false, true, true
	):
		var bullet: Volcano = j
		bullet.baseDamage = readStore("atk")
		bullet.rotates = readStore("rotate")
		bullet.damageMultipliers = [readStore("dmg1"), readStore("dmg2"), readStore("dmg3"), readStore("dmg4")]
		bullet.count = readStore("count")
		bullet.dmg5 = readStore("dmg5")
