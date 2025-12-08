@tool
extends Weapon
class_name ShieldWeapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
	origin["atk"] += 2 * to * soulLevel
	return origin
func attack(entity: EntityBase):
	var summon = entity.summon(ComponentManager.getSummon("Shield"))
	if !summon: return true
	summon.fields[FieldStore.Entity.MAX_HEALTH] = readStore("atk")
	summon.health = summon.fields[FieldStore.Entity.MAX_HEALTH]
	return true
