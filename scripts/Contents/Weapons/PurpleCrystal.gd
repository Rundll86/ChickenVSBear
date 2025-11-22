@tool
extends Weapon
class_name PurpleCrystalWeapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["atk"] += 5 * to * soulLevel
	return origin
func attack(entity: EntityBase):
	var weaponPos = entity.findWeaponAnchor("normal")
	for bullet in BulletBase.generate(ComponentManager.getBullet("PurpleCrystal"), entity, weaponPos, (get_global_mouse_position() - weaponPos).angle()):
		if bullet is BulletBase:
			bullet.baseDamage = readStore("atk")
	return true
