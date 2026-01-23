extends AcidBulletBase
class_name AcidP

func succeedToHit(_dmg: float, entity: EntityBase):
    entity.fields[FieldStore.Entity.OFFSET_SHOOT] = clamp(entity.fields[FieldStore.Entity.OFFSET_SHOOT] + arg1, 0, INF)
