extends BulletBase

func register():
	speed = 1
func ai():
	speed *= 1.1
	damage = speed
	PresetBulletAI.forward(self, rotation)
