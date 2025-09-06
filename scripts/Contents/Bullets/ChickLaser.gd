extends BulletBase
class_name Laser

func register():
	penerate = 1
func ai():
	rotation_degrees += 1
	PresetBulletAI.lockLauncher(self, launcher, true)
