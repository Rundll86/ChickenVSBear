@tool
extends Weapon

func update(to, origin, _entity):
	origin["atk"] += 3 * to * soulLevel
	origin["count"] = 1 * soulLevel
	origin["childatk"] = 2 * to * soulLevel
	return origin
func attack(entity: EntityBase):
	var weaponPos = entity.findWeaponAnchor("normal")
	for i in BulletBase.generate(ComponentManager.getBullet("Meowmere"), entity, weaponPos, weaponPos.angle_to_point(get_global_mouse_position())):
		i.damage = readStore("atk")
	for i in readStore("count"):
		for j in BulletBase.generate(ComponentManager.getBullet("RainbowCat"), entity, weaponPos, weaponPos.angle_to_point(get_global_mouse_position())):
			j.damage = readStore("childatk")
