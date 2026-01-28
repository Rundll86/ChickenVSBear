@tool
extends Weapon
class_name ShieldWeapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["atk"] += 2 * to * soulLevel
	return origin
func attack(entity: EntityBase):
	var summon = entity.summon(ComponentManager.getSummon("Shield"))
	if summon:
		summon.initHealth(readStore("atk"))
	return true
