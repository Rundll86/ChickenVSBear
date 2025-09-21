extends BulletBase
class_name RainbowCat

func register():
	penerate = 1
func ai():
	PresetBulletAI.forward(self, rotation)
