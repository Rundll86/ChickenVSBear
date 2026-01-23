extends AcidBulletBase
class_name AcidC

func ai():
    super.ai()
    scale *= 1.01
    modulate.a = 1 - timeLived() / lifeTime
func split(newBullet: BulletBase, _index: int, _total: int, _lastBullet: float):
    newBullet.scale = scale.sign()
    return newBullet
