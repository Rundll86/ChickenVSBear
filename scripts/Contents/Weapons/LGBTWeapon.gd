@tool
extends Weapon
class_name LGBTWeapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["angle"] /= 1 + 0.025 * to * soulLevel
	origin["count"] = soulLevel + 1
	origin["atk"] += 2 * to * soulLevel
	origin["power"] += 0.005 * to * soulLevel
	origin["trace"] += 0.05 * to * soulLevel
	return origin
func attack(entity: EntityBase):
	var summon = entity.summon(ComponentManager.getSummon("LGBTFlag"))
	if !summon: return true
	summon.atk = readStore("atk")
	summon.maxTraceTime = readStore("trace") * 1000
	summon.tracePower = readStore("power")
	summon.count = readStore("count")
	summon.angle = readStore("angle")
	return true
