extends BulletBase
class_name Laser

func ai():
	rotation_degrees += 1
	PresetBulletAI.lockLauncher(self, launcher, true)
