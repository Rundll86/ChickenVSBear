extends BulletBase

func register():
	speed = 1
func ai():
	speed *= 1.05
	damage = speed
	PresetBulletAI.forward(self, rotation)
