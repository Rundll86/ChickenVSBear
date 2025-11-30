@tool
extends Weapon

func attack(entity: EntityBase):
	playSound("attack")
	for i in 6:
		for bullet in BulletBase.generate(ComponentManager.getBullet("SevenSoul"), entity, entity.texture.global_position, 0):
			if bullet is SevenSoulBullet:
				bullet.index = i
				bullet.baseDamage = readStore("atk")
				bullet.energyCollect = readStore("dmg")
				bullet.healAmount = readStore("heal")
		await TickTool.millseconds(15000 / 6.0)
func update(to, origin, _entity):
	origin["atk"] += 1 * to * soulLevel
	origin["dmg"] += 0.02 * to * soulLevel
	origin["heal"] += 0.1 * to * soulLevel
	return origin
