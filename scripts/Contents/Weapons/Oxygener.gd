@tool
extends Weapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["atk"] += 1 * to * soulLevel
	origin["fireatk"] += 0.5 * to * soulLevel
	origin["max-n"] += 2 * soulLevel
	return origin
func attack(entity: EntityBase):
	for bullet in BulletBase.generate(
		ComponentManager.getBullet("OxygenFire"),
		entity,
		entity.findWeaponAnchor("normal"),
		entity.position.angle_to_point(get_global_mouse_position()),
	):
		if bullet is OxygenFire:
			bullet.baseDamage = readStore("fireatk")
			if MathTool.rate(0.1):
				for i in randi_range(readStore("min-n"), readStore("max-n")):
					for n in BulletBase.generate(
						ComponentManager.getBullet("AcidN"),
						entity,
						bullet.position,
						0,
					):
						if n is AcidN:
							n.baseDamage = readStore("atk")
							n.storm = bullet
	return true
