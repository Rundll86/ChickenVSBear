extends BulletBase
class_name Star

func register():
	damage = 1
func ai():
	PresetsAI.forward(self, rotation)
