@tool
extends Weapon
class_name LGBTWeapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["atk"] += 2 * to
	origin["count"] += 1
	origin["power"] += 0.03
	origin["trace"] += 0.25
	origin["angle"] -= 0.1
	return origin
func attack(entity: EntityBase):
	var weaponPos = entity.findWeaponAnchor("normal")
	var facingAngle = (get_global_mouse_position() - weaponPos).angle()
	var startAngle = facingAngle - deg_to_rad(readStore("angle") * (readStore("count") / 2))
	for i in range(int(readStore("count"))):
		for j in BulletBase.generate(preload("res://components/Bullets/LGBTBullet.tscn"), entity, weaponPos, startAngle + deg_to_rad(readStore("angle") * i)):
			var bullet: LGBTBullet = j
			bullet.damage = readStore("atk")
			bullet.tracer = EntityTool.findClosetEntity(get_global_mouse_position(), get_tree(), !entity.isPlayer(), entity.isPlayer())
			bullet.maxTraceTime = readStore("trace") * 1000
			bullet.tracePower = readStore("power")
	return true
