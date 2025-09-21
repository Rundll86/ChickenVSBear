@tool
extends Weapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["atk"] += 25 * to * soulLevel
	origin["radius"] += 20 * to * soulLevel
	return origin
func attack(entity: EntityBase):
	var weaponPos = entity.findWeaponAnchor("normal")
	for j in BulletBase.generate(load("res://components/Bullets/NuclearBomb.tscn"), entity, weaponPos, weaponPos.angle_to_point(get_global_mouse_position())):
		var bullet: NuclearBomb = j
		bullet.damage = readStore("atk")
		bullet.radius = readStore("radius")
	return true
