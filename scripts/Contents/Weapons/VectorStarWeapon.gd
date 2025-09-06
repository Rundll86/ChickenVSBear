@tool
extends Weapon
class_name VectorStarWeapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["atk"] += 2 * to
	origin["forwardtime"] /= 1.05 * to
	origin["mincount"] += 1 * level
	origin["maxcount"] += 1 * level
	return origin
func attack(entity: EntityBase):
	var weaponPos = entity.findWeaponAnchor("normal")
	for i in range(int(randi_range(readStore("mincount"), readStore("maxcount")))):
		for j in BulletBase.generate(preload("res://components/Bullets/VectorStar.tscn"), entity, weaponPos, deg_to_rad(randf_range(0, 360))):
			var bullet: VectorStar = j
			bullet.damage = readStore("atk")
			bullet.tracer = EntityTool.findClosetEntity(get_global_mouse_position(), get_tree(), !entity.isPlayer(), entity.isPlayer())
			bullet.forwardTime = readStore("forwardtime") * 1000
	return true
