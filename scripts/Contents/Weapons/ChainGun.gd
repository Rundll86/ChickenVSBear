@tool
extends Weapon

func update(to, origin, _entity):
	origin["atk"] += 1 * to * soulLevel
	return origin
func attack(entity: EntityBase):
	var weaponPos = entity.findWeaponAnchor("normal")
	for i in BulletBase.generate(ComponentManager.getBullet("PurpleCrystalSmall"), entity, weaponPos, (get_global_mouse_position() - weaponPos).angle()):
		i.damage = readStore("atk")
