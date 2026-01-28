@tool
extends Weapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
    origin["health"] += 5 * to * soulLevel
    origin["percent"] += 0.02 * to * soulLevel
    return origin
func attack(entity: EntityBase):
    var gobo = entity.summon(ComponentManager.getSummon("Gobo"))
    if gobo is GoboSummon:
        gobo.percent = readStore("percent")
        gobo.initHealth(readStore("health"))
    return true
