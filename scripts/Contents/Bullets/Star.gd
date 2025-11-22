extends BulletBase
class_name Star

func register():
	baseDamage = 1
func ai():
	PresetBulletAI.forward(self, rotation)
