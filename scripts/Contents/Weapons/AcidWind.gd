@tool
extends Weapon

var acids: Array[String] = ["AcidS", "AcidN", "AcidCl", "AcidP", "AcidC"]

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["atk"] += 0.15 * to * soulLevel
	origin["c-atk"] *= soulLevel
	origin["cl-atkspeed"] *= soulLevel
	origin["cl-speed"] *= soulLevel
	origin["n-atk"] *= soulLevel
	origin["p-offset"] *= soulLevel
	origin["s-count-max"] *= soulLevel
	origin["weakatk"] += 0.075 * to * soulLevel
	origin["f"] += 15 * (soulLevel - 1)
	return origin
func attack(entity: EntityBase):
	for bullet in BulletBase.generate(
		ComponentManager.getBullet("AcidStorm"),
		entity,
		entity.findWeaponAnchor("normal"),
		(get_global_mouse_position() - entity.findWeaponAnchor("normal")).angle(),
	):
		if bullet is AcidStormBullet:
			bullet.strongAtk = readStore("atk")
			bullet.weakAtk = readStore("weakatk")
			bullet.sCountMax = readStore("s-count-max")
			bullet.nAtk = readStore("n-atk")
			bullet.clSpeed = readStore("cl-speed")
			bullet.clAtkSpeed = readStore("cl-atkspeed")
			bullet.cAtk = readStore("c-atk")
			bullet.pOffset = readStore("p-offset")
			bullet.f = readStore("f")
	return true
