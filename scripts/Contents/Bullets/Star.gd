extends BulletBase
class_name Star

func register():
	damage = 5
func ai():
	PresetAIs.forward(self, rotation)
