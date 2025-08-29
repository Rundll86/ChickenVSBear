extends BulletBase
class_name FireScan

func register():
	speed = 2
	damage = 1

func ai():
	PresetsAI.forward(self, rotation)
