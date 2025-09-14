extends BulletBase
class_name FireScan

func register():
	speed = 10
	damage = 20

func ai():
	PresetBulletAI.forward(self, rotation)
