extends BulletBase
class_name FireScan

func ai():
	PresetBulletAI.forward(self, rotation)
	damage = (1 - lifeDistancePercent()) * originalDamage
