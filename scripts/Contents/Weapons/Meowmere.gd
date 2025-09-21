@tool
extends Weapon

func update(to, origin, _entity):
	origin["atk"] += 7 * to * soulLevel
	origin["count"] = 1 * soulLevel
	return origin
func attack(entity: EntityBase):
	var weaponPos = entity.findWeaponAnchor("normal")
	for i in BulletBase.generate(preload("res://components/Bullets/Meowmere.tscn"), entity, weaponPos, weaponPos.angle_to_point(get_global_mouse_position())):
		i.damage = readStore("atk")
	for i in readStore("count"):
		BulletBase.generate(preload("res://components/Bullets/RainbowCat.tscn"), entity, weaponPos, weaponPos.angle_to_point(get_global_mouse_position()))
