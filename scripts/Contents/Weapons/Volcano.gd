@tool
extends Weapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["atk"] += 3 * to * soulLevel
	origin["rotate"] += 0.015 * to * soulLevel
	return origin
func attack(entity: EntityBase):
	for j in BulletBase.generate(
		ComponentManager.getBullet("Volcano"),
		entity,
		entity.findWeaponAnchor("normal"),
		entity.position.angle_to_point(entity.get_global_mouse_position()), false, false, true, true
	):
		var bullet: Volcano = j
		bullet.damage = readStore("atk")
		bullet.rotates = readStore("rotate")
