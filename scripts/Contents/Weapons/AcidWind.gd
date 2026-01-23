@tool
extends Weapon

var acids: Array[String] = ["AcidS", "AcidN", "AcidCl", "AcidP", "AcidC"]

func update(to: int, origin: Dictionary, _entity: EntityBase):
    origin["atk"] += 0.05 * to * soulLevel
    origin["c-atk"] *= soulLevel
    origin["cl-atkspeed"] *= soulLevel
    origin["cl-speed"] *= soulLevel
    origin["n-atk"] *= soulLevel
    origin["p-offset"] *= soulLevel
    origin["s-count-max"] *= soulLevel
    origin["weakatk"] = 0.025 * soulLevel
    return origin
func attack(entity: EntityBase):
    for bullet in BulletBase.generate(
        ComponentManager.getBullet(MathTool.randomChoiceFrom(acids)),
        entity,
        entity.findWeaponAnchor("normal"),
        (get_global_mouse_position() - entity.findWeaponAnchor("normal")).angle()
    ):
        if bullet is AcidBulletBase:
            if bullet.acidType == AcidBulletBase.AcidType.STRONG:
                bullet.baseDamage = readStore("atk")
            else:
                bullet.baseDamage = readStore("weakatk")
            if bullet is AcidS:
                bullet.arg1 = readStore("s-count-max")
            if bullet is AcidN:
                bullet.arg1 = readStore("n-atk")
            if bullet is AcidCl:
                bullet.arg1 = readStore("cl-speed")
                bullet.arg2 = readStore("cl-atkspeed")
            if bullet is AcidP:
                bullet.arg1 = readStore("p-offset")
            if bullet is AcidC:
                bullet.rotation += deg_to_rad(randf_range(-1, 1) * 15)
