extends AcidBulletBase
class_name AcidC

func ai():
    super.ai()
    scale *= 1.01
    modulate.a = 1 - timeLived() / lifeTime
