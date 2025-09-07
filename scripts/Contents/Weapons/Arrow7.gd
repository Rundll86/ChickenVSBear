@tool
extends Weapon
class_name Arrow7Weapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["atk"] += 5 * to
	origin["count"] += 1 * to
	return origin
func attack(entity: EntityBase):
	var weaponPos = entity.findWeaponAnchor("normal")
	for i in range(readStore("count")):
		for bullet in BulletBase.generate(preload("res://components/Bullets/BossAttack/Bear/ArrowSeven.tscn"), entity, weaponPos, deg_to_rad(randf_range(0, 360))):
			bullet.damage = readStore("atk")
			bullet.tracer = EntityTool.findClosetEntity(entity.position, get_tree(), false, true)
	return true
