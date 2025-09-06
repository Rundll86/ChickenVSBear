@tool
extends Weapon
class_name PurpleCrystalWeapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["atk"] += 5 * to
	return origin
func attack(entity: EntityBase):
	var weaponPos = entity.findWeaponAnchor("normal")
	for bullet in BulletBase.generate(preload("res://components/Bullets/PurpleCrystal.tscn"), entity, weaponPos, (get_global_mouse_position() - weaponPos).angle()):
		bullet.damage = readStore("atk")
	return true
