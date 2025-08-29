extends BulletBase
class_name ChickSprint

func register():
	speed = 0
	damage = 20
	penerate = 1
func ai():
	PresetsAI.lockLauncher(self, launcher, true)
	if !launcher.sprinting:
		tryDestroy()
