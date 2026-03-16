@tool
extends Weapon

func attack(entity: EntityBase):
	for bullet in BulletBase.generate(
		ComponentManager.getBullet("Parrier"),
		entity,
		entity.findWeaponAnchor("normal"),
		entity.findWeaponAnchor("normal").angle_to_point(get_global_mouse_position()),
	):
		if bullet is ParrierBullet:
			pass
	return true
