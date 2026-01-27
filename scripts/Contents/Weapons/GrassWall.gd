@tool
extends Weapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
    origin["atk"] += 3 * to * soulLevel
    return origin
func attack(entity: EntityBase):
    var wall = ObstacleBase.generate(
        ComponentManager.getObstacle("GrassWall"),
        get_global_mouse_position(),
        entity.findWeaponAnchor("normal").angle_to_point(get_global_mouse_position()),
        entity
    )
    wall.initHealth(readStore("atk"))
