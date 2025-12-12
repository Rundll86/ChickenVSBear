@tool
extends Weapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["atk"] += 1 * to * soulLevel
	origin["count"] = 1 * soulLevel
	return origin
func attack(entity: EntityBase):
	for i in BulletBase.generate(ComponentManager.getBullet("BlueCrystal"), entity, entity.findWeaponAnchor("normal"), deg_to_rad(randf_range(0, 360))):
		if i is BlueCrystalBullet:
			i.tracer = EntityTool.findClosetEntity(get_global_mouse_position(), get_tree(), !entity.isPlayer(), entity.isPlayer())
			i.baseDamage = readStore("atk")
			for index in readStore("count"):
				for j in BulletBase.generate(ComponentManager.getBullet("Diamond2"), entity, i.position, deg_to_rad(360.0 / readStore("count") * index)):
					if j is Diamond2Bullet:
						j.baseDamage = readStore("atk")
						j.parent = i
