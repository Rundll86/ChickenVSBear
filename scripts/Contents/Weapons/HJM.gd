@tool
extends Weapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["time"] /= 1 + 0.05 * to * soulLevel
	origin["atk"] += 2 * to * soulLevel
	return origin
func attack(entity: EntityBase):
	var summon = entity.summon(ComponentManager.getSummon("HJM"))
	summon.atk = readStore("atk")
	summon.attackTime = readStore("time") * 1000
	return true
