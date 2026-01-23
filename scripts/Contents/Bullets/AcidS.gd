extends AcidBulletBase
class_name AcidS

func succeedToHit(_dmg: float, _entity: EntityBase):
    for i in randi_range(0, int(arg1)):
        for bullet in BulletBase.generate(ComponentManager.getBullet("AcidS"), launcher, position, rotation + deg_to_rad(180 + 90 * randf_range(-1, 1)), true, true):
            if bullet is AcidS:
                bullet.baseDamage = baseDamage
