@tool
extends Weapon
class_name LGBTWeapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["atk"] += 5 * to
	origin["count"] += 1
	origin["power"] += 0.05
	origin["trace"] += 0.25
	origin["angle"] /= 1.1
	return origin
func attack(entity: EntityBase):
	var weaponPos = entity.findWeaponAnchor("normal")
	var facingAngle = (get_global_mouse_position() - weaponPos).angle()
	var startAngle = facingAngle - deg_to_rad(readStore("angle") * (readStore("count") / 2))
	for i in range(int(readStore("count"))):
		BulletBase.generate(preload("res://components/Bullets/LGBTBullet.tscn"), entity, weaponPos, startAngle + deg_to_rad(readStore("angle") * i))
	return true
