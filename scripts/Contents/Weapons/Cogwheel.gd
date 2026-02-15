@tool
extends Weapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
    origin["atk"] += 2 * to * soulLevel
    origin["rotate"] += 1 * to * soulLevel
    return origin
func attack(entity: EntityBase):
    var weaponPos = entity.findWeaponAnchor("normal")
    for bullet in BulletBase.generate(
        ComponentManager.getBullet("Cogwheel"),
        entity,
        weaponPos,
        weaponPos.angle_to_point(get_global_mouse_position()),
    ):
        if bullet is CogwheelBullet:
            bullet.initialRotate = readStore("rotate")
            bullet.rotateSpeed = readStore("rotate")
            bullet.baseDamage = readStore("atk")
    return true
