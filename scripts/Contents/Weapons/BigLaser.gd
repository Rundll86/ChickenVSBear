@tool
extends Weapon
class_name BigLaserWeapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["atk"] += 5 * to * soulLevel
	origin["time"] /= 1.05 ** soulLevel * to
	return origin
func attack(entity: EntityBase):
	var weaponPos = entity.findWeaponAnchor("normal")
	for bullet in BulletBase.generate(preload("res://components/Bullets/BigLaser.tscn"), entity, weaponPos, (get_global_mouse_position() - weaponPos).angle()):
		var bigLaser: BigLaser = bullet
		bigLaser.dotTime = readStore("time") * 1000
		bigLaser.damage = readStore("atk")
	return true
