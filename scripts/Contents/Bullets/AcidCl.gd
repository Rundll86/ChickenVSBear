extends AcidBulletBase
class_name AcidCl

func succeedToHit(_dmg: float, entity: EntityBase):
    entity.fields[FieldStore.Entity.MOVEMENT_SPEED] = clamp(entity.fields[FieldStore.Entity.MOVEMENT_SPEED] - arg1, 0.15, INF)
    entity.fields[FieldStore.Entity.ATTACK_SPEED] = clamp(entity.fields[FieldStore.Entity.ATTACK_SPEED] - arg2, 0.15, INF)
