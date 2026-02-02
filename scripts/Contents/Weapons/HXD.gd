@tool
extends Weapon

func update(to: int, origin: Dictionary, _entity: EntityBase):
    origin["atk"] += 1 * to * soulLevel
    return origin
func attack(entity: EntityBase):
    for i in readStore("atk"):
        for bullet in BulletBase.generate(
            ComponentManager.getBullet("HXD"),
            entity,
            entity.findWeaponAnchor("normal"),
            entity.findWeaponAnchor("normal").angle_to_point(get_global_mouse_position()) + deg_to_rad(randf_range(-1, 1) * 40)
        ):
            if bullet is HXDBullet:
                bullet.maxBouncedTime = readStore("atk")
                bullet.baseDamage = readStore("atk")
