@tool
extends Weapon
class_name LGBTWeapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["atk"] += 5 * to * soulLevel
	origin["power"] += 0.05 * to * soulLevel
	origin["trace"] += 0.25 * to * soulLevel
	return origin
func attack(entity: EntityBase):
	var summon = entity.summon(ComponentManager.getSummon("LGBTFlag"))
	summon.atk = readStore("atk")
	summon.maxTraceTime = readStore("trace") * 1000
	summon.tracePower = readStore("power")
	return true
