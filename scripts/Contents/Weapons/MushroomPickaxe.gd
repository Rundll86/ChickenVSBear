@tool
extends Weapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["atk"] += 0.5 * to
	origin["rate"] += 0.02 * to
	origin["count"] += 1 * level
	return origin
func attack(entity: EntityBase):
	var weaponPos = entity.findWeaponAnchor("normal")
	for j in BulletBase.generate(preload("res://components/Bullets/MushroomPickaxe.tscn"), entity, entity.texture.global_position, weaponPos.angle_to_point(get_global_mouse_position())):
		var bullet: MushroomPickaxe = j
		bullet.damage = readStore("atk")
		bullet.rate = readStore("rate")
		bullet.count = readStore("count")
	return true
