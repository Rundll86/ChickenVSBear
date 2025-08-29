extends BulletBase
class_name FireScan

func register():
	speed = 10
	damage = 5

func ai():
	PresetAIs.forward(self, rotation)
