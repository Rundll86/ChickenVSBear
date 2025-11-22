@tool
extends Weapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["atk"] += 50 * to * soulLevel
	origin["radius"] += 15 * to * soulLevel
	return origin
func attack(entity: EntityBase):
	var weaponPos = entity.findWeaponAnchor("normal")
	for j in BulletBase.generate(ComponentManager.getBullet("NuclearBomb"), entity, weaponPos, weaponPos.angle_to_point(get_global_mouse_position())):
		var bullet: NuclearBomb = j
		bullet.baseDamage = readStore("atk")
		bullet.radius = readStore("radius")
	return true
