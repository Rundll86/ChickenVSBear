@tool
extends Weapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["atk"] += 5 * to * soulLevel
	origin["count"] += 1 * (soulLevel - 1)
	origin["rotate"] += 0.1 * to * soulLevel
	origin["life"] += 0.05 * to * soulLevel
	return origin
func attack(entity: EntityBase):
	for i in readStore("count"):
		for j in BulletBase.generate(ComponentManager.getBullet("Volcano"), entity, entity.findWeaponAnchor("normal"), deg_to_rad(360.0 / readStore("count") * i)):
			var bullet: Volcano = j
			bullet.damage = readStore("atk")
			bullet.rotates = readStore("rotate")
			bullet.lifeTime = readStore("life") * 1000
