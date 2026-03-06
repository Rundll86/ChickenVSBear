extends AcidBulletBase
class_name AcidN

func succeedToHit(_dmg: float, entity: EntityBase):
    entity.takeDamage(baseDamage * arg1)
