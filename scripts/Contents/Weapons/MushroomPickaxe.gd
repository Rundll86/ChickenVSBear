@tool
extends Weapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["atk"] += 0.5 * to * soulLevel
	origin["rate"] = 0.1 * soulLevel
	origin["count"] += 1 * to * soulLevel
	return origin
func attack(entity: EntityBase):
	var weaponPos = entity.findWeaponAnchor("normal")
	for j in BulletBase.generate(ComponentManager.getBullet("MushroomPickaxe"), entity, entity.texture.global_position, weaponPos.angle_to_point(get_global_mouse_position())):
		var bullet: MushroomPickaxe = j
		bullet.baseDamage = readStore("atk")
		bullet.rate = readStore("rate")
		bullet.count = readStore("count")
	return true
