@tool
extends Weapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
    origin["health"] += 5 * to * soulLevel
    origin["percent"] += 0.02 * to * soulLevel
    origin["count"] *= to * soulLevel
    return origin
func attack(entity: EntityBase):
    var gobo = entity.summon(ComponentManager.getSummon("Gobo"))
    if gobo is GoboSummon:
        gobo.targetDamage = readStore("atk")
        gobo.percent = readStore("percent")
        gobo.count = readStore("count")
        gobo.initHealth(readStore("health"))
    return true
