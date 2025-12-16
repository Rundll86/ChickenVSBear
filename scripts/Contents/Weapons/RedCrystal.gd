@tool
extends Weapon
class_name RedCrystalWeapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["atk"] += 5 * to * soulLevel
	origin["radius"] += 1 * to * soulLevel
	return origin
func attack(entity: EntityBase):
	var weaponPos = entity.findWeaponAnchor("normal")
	for bullet in BulletBase.generate(ComponentManager.getBullet("RedCrystal"), entity, weaponPos, (get_global_mouse_position() - weaponPos).angle()):
		if bullet is RedCrystalBullet:
			bullet.baseDamage = readStore("atk")
			bullet.radius = readStore("radius")
	return true
