@tool
extends Weapon

func update(to, origin, _entity):
	origin["atk"] += 1.5 * to * soulLevel
	origin["count"] = 1 * soulLevel
	origin["childatk"] = 1.25 * origin["atk"]
	origin["reduce"] /= 1 + 0.05 * to * soulLevel
	return origin
func attack(entity: EntityBase):
	var weaponPos = entity.findWeaponAnchor("normal")
	for i in BulletBase.generate(ComponentManager.getBullet("Meowmere"), entity, weaponPos, weaponPos.angle_to_point(get_global_mouse_position())):
		if i is BulletBase:
			i.baseDamage = readStore("atk")
	for i in readStore("count"):
		for j in BulletBase.generate(ComponentManager.getBullet("RainbowCat"), entity, weaponPos, weaponPos.angle_to_point(get_global_mouse_position())):
			if j is BulletBase:
				j.baseDamage = readStore("childatk")
				j.penerateDamageReduction = readStore("reduce")
	return true
