extends AcidBulletBase
class_name AcidC

func succeedToHit(_dmg: float, entity: EntityBase):
	entity.fields[FieldStore.Entity.DAMAGE_MULTIPILER] = clamp(entity.fields[FieldStore.Entity.DAMAGE_MULTIPILER] - arg1, 0.2, INF)
func split(newBullet: BulletBase, _index: int, _total: int, _lastBullet: float):
	newBullet.scale = scale.sign()
	return newBullet
