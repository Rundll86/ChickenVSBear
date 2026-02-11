@tool
extends Weapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["atk"] += 1 * to * soulLevel
	return origin
func attack(entity: EntityBase):
	var weaponPos = entity.findWeaponAnchor("normal")
	for bullet in BulletBase.generate(
			ComponentManager.getBullet("Pipe"),
			entity,
			weaponPos,
			weaponPos.angle_to_point(get_global_mouse_position())
		):
		if bullet is PipeBullet:
			var e = charged(readStore("atk"), 0.1)
			bullet.baseDamage = e
			bullet.energy = e
			bullet.speed = sqrt(e)
	return true
