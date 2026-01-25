@tool
extends Weapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
    origin["atk"] += 1 * to * soulLevel
    origin["fireatk"] += 0.5 * to * soulLevel
    origin["max-n"] *= soulLevel
    return origin
func attack(entity: EntityBase):
    var bulletName = MathTool.randomChoiceFromWeights(["OxygenFire", "AcidN"], [10, 1])
    for i in randi_range(readStore("min-n"), readStore("max-n")) if bulletName == "AcidN" else 1:
        for bullet in BulletBase.generate(
            ComponentManager.getBullet(bulletName),
            entity,
            entity.findWeaponAnchor("normal"),
            entity.position.angle_to_point(get_global_mouse_position()),
        ):
            if bullet is OxygenFire:
                bullet.baseDamage = readStore("fireatk")
            elif bullet is AcidN:
                bullet.baseDamage = readStore("atk")
