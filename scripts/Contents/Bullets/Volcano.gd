extends BulletBase
class_name Volcano

var rotates: float = 0

func ai():
	PresetBulletAI.selfRotate(self, rotates)
	PresetBulletAI.lockLauncher(self, launcher, true)
