@tool
extends Weapon
class_name VectorStarWeapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["atk"] += 5 * to * soulLevel
	origin["forwardtime"] /= 1 + 0.05 * to * soulLevel
	origin["mincount"] += 0.5 * to * soulLevel
	origin["maxcount"] += 1.5 * to * soulLevel
	return origin
func attack(entity: EntityBase):
	var weaponPos = entity.findWeaponAnchor("normal")
	for i in range(int(randi_range(readStore("mincount"), readStore("maxcount")))):
		for j in BulletBase.generate(ComponentManager.getBullet("VectorStar"), entity, weaponPos, deg_to_rad(randf_range(0, 360))):
			var bullet: VectorStar = j
			bullet.damage = readStore("atk")
			bullet.tracer = EntityTool.findClosetEntity(get_global_mouse_position(), get_tree(), !entity.isPlayer(), entity.isPlayer())
			bullet.forwardTime = readStore("forwardtime") * 1000
	return true
