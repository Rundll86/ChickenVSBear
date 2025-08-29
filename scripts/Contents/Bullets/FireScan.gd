extends BulletBase
class_name FireScan

func register():
	speed = 5
	damage = 20

func ai():
	PresetsAI.forward(self, rotation)
